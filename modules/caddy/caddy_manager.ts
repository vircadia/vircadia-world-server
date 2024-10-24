import type { Subprocess } from "bun";
import { log } from "../general/log.ts";
import type { Server } from "../vircadia-world-sdk-ts/shared/modules/vircadia-world-meta/typescript/meta.ts";

export interface ProxyConfig {
	subdomain: string; // e.g., "general.localhost", "supabase.localhost"
	to: string;
	name: string;
}

export class CaddyManager {
	private static instance: CaddyManager;
	private caddyProcess: Subprocess | null = null;
	private caddyfilePath: string;
	private port: number;

	private constructor() {
		this.caddyfilePath = "./modules/caddy/tmp/Caddyfile";
		this.port = 3010; // Default port, can be made configurable
	}

	public static getInstance(): CaddyManager {
		if (!CaddyManager.instance) {
			CaddyManager.instance = new CaddyManager();
		}
		return CaddyManager.instance;
	}

	public async setupAndStart(data: {
		proxyConfigs: Record<Server.E_ProxySubdomain, ProxyConfig>;
		debug: boolean;
	}): Promise<void> {
		await this.createCaddyfile(data);
		await this.startCaddy({
			debug: data.debug,
		});
	}

	private async createCaddyfile(data: {
		proxyConfigs: Record<Server.E_ProxySubdomain, ProxyConfig>;
		debug: boolean;
	}): Promise<void> {
		let caddyfileContent = "";

		if (data.debug) {
			caddyfileContent += `{
    debug
}

`;
		}

		const subdomains = [
			...new Set(
				Object.values(data.proxyConfigs).map((config) => config.subdomain),
			),
		];
		caddyfileContent += `:${this.port} {
    @general host general.localhost
    reverse_proxy @general localhost:3000

`;

		// Group proxy configs by subdomain
		const configsBySubdomain = Object.values(data.proxyConfigs).reduce(
			(acc, config) => {
				if (!acc[config.subdomain]) {
					acc[config.subdomain] = [];
				}
				acc[config.subdomain].push(config);
				return acc;
			},
			{} as Record<string, ProxyConfig[]>,
		);

		// Create subdomain configurations
		for (const [subdomain, configs] of Object.entries(configsBySubdomain)) {
			if (subdomain !== "general.localhost") {
				caddyfileContent += `    @${subdomain.replace(
					".",
					"_",
				)} host ${subdomain}
`;
				for (const config of configs) {
					log({
						message: `Creating Caddy route for ${subdomain} to ${config.to}`,
						type: "info",
					});
					caddyfileContent += `    reverse_proxy @${subdomain.replace(
						".",
						"_",
					)} ${config.to}
`;
				}
			}
		}

		caddyfileContent += "}";

		await Bun.write(this.caddyfilePath, caddyfileContent);
		log({
			message: `Caddyfile created at ${this.caddyfilePath}`,
			type: "info",
		});
	}

	private async startCaddy(data: { debug: boolean }): Promise<void> {
		const args = [
			"run",
			"--config",
			this.caddyfilePath,
			"--adapter",
			"caddyfile",
		];

		this.caddyProcess = Bun.spawn(["caddy", ...args], {
			stdout: "pipe",
			stderr: "pipe",
		});

		log({
			message: "Caddy server started",
			type: "info",
		});

		// Handle Caddy output
		const logOutput = (stream: ReadableStream) => {
			stream.pipeTo(
				new WritableStream({
					write(chunk) {
						const message = new TextDecoder().decode(chunk).trim();
						if (message) {
							log({
								message,
								type: "info",
							});
						}
					},
				}),
			);
		};

		if (this.caddyProcess.stdout) logOutput(this.caddyProcess.stdout);
		if (this.caddyProcess.stderr) logOutput(this.caddyProcess.stderr);
	}

	public async stop(): Promise<void> {
		if (this.caddyProcess) {
			this.caddyProcess.kill();
			this.caddyProcess = null;
			log({
				message: "Caddy server stopped",
				type: "info",
			});
			log({
				message: "Caddy server stopped",
				type: "info",
			});
		}
	}

	public isRunning(): boolean {
		return this.caddyProcess !== null;
	}
}
