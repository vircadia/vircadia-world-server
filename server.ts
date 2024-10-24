import { build } from "bun"; // Use Bun's bundler instead of Deno's
import { parseArgs } from "node:util";
import {
	CaddyManager,
	type ProxyConfig,
} from "./modules/caddy/caddy_manager.ts";
import { log } from "./modules/general/log.ts";
import { Supabase } from "./modules/supabase/supabase_manager.ts";
import { Server } from "./modules/vircadia-world-sdk-ts/shared/modules/vircadia-world-meta/typescript/meta.ts";

// TODO:(@digisomni)
/*
 * we need to make Caddy issue certs for us automatically, OR allow for a custom CA to be used.
 */

const ENVIRONMENT_PREFIX = "VIRCADIA_WORLD";
const ENVIRONMENT_SERVER_PREFIX = "SERVER";

export enum CONFIG_VARIABLE {
	SERVER_DEBUG = `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_DEBUG`,
	SERVER_CADDY_HOST = `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_CADDY_HOST`,
	SERVER_CADDY_PORT = `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_CADDY_PORT`,
	SERVER_HOST = `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_HOST`,
	SERVER_PORT = `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_PORT`,
	FORCE_RESTART_SUPABASE = `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_FORCE_RESTART_SUPABASE`,
}

const config = loadConfig();

async function init() {
	const debugMode = config[CONFIG_VARIABLE.SERVER_DEBUG];

	if (debugMode) {
		log({ message: "Server debug mode enabled", type: "info" });
	}

	log({ message: "Starting Vircadia World Server", type: "info" });

	await startSupabase(debugMode);
	await startBunServer(debugMode);
	const caddyRoutes = await setupCaddyRoutes(debugMode);
	await startCaddyServer(caddyRoutes, debugMode);
}

async function startSupabase(debugMode: boolean) {
	log({ message: "Starting Supabase", type: "info" });
	if (debugMode) {
		log({ message: "Supabase debug mode enabled", type: "info" });
	}

	const supabase = Supabase.getInstance(debugMode);
	const forceRestart = config[CONFIG_VARIABLE.FORCE_RESTART_SUPABASE];
	const isRunning = await supabase.isRunning();

	if (!isRunning || forceRestart) {
		try {
			await supabase.initializeAndStart({
				forceRestart: forceRestart,
			});
		} catch (error) {
			log({
				message: `Failed to initialize and start Supabase: ${error}`,
				type: "error",
			});
			await supabase.debugStatus();
		}

		if (!(await supabase.isRunning())) {
			log({
				message:
					"Supabase services are not running after initialization. Exiting.",
				type: "error",
			});
			process.exit(1);
		}
	}

	log({ message: "Supabase services are running correctly.", type: "info" });
}

async function setupCaddyRoutes(
	debugMode: boolean,
): Promise<Record<Server.E_ProxySubdomain, ProxyConfig>> {
	log({ message: "Creating Caddy routes", type: "info" });

	const supabaseStatus = await Supabase.getInstance(debugMode).getStatus();

	return {
		[Server.E_ProxySubdomain.SUPABASE_API]: {
			subdomain: `${Server.E_ProxySubdomain.SUPABASE_API}.${
				config[CONFIG_VARIABLE.SERVER_CADDY_HOST]
			}`,
			to: `localhost:${supabaseStatus.api.port}${supabaseStatus.api.path}`,
			name: "Supabase API",
		},
		[Server.E_ProxySubdomain.SUPABASE_GRAPHQL]: {
			subdomain: `${Server.E_ProxySubdomain.SUPABASE_GRAPHQL}.${
				config[CONFIG_VARIABLE.SERVER_CADDY_HOST]
			}`,
			to: `localhost:${supabaseStatus.graphql.port}${supabaseStatus.graphql.path}`,
			name: "Supabase GraphQL",
		},
		[Server.E_ProxySubdomain.SUPABASE_STORAGE]: {
			subdomain: `${Server.E_ProxySubdomain.SUPABASE_STORAGE}.${
				config[CONFIG_VARIABLE.SERVER_CADDY_HOST]
			}`,
			to: `localhost:${supabaseStatus.s3Storage.port}${supabaseStatus.s3Storage.path}`,
			name: "Supabase Storage",
		},
		[Server.E_ProxySubdomain.SUPABASE_STUDIO]: {
			subdomain: `${Server.E_ProxySubdomain.SUPABASE_STUDIO}.${
				config[CONFIG_VARIABLE.SERVER_CADDY_HOST]
			}`,
			to: `localhost:${supabaseStatus.studio.port}${supabaseStatus.studio.path}`,
			name: "Supabase Studio",
		},
		[Server.E_ProxySubdomain.SUPABASE_INBUCKET]: {
			subdomain: `${Server.E_ProxySubdomain.SUPABASE_INBUCKET}.${
				config[CONFIG_VARIABLE.SERVER_CADDY_HOST]
			}`,
			to: `localhost:${supabaseStatus.inbucket.port}${supabaseStatus.inbucket.path}`,
			name: "Supabase Inbucket",
		},
		[Server.E_ProxySubdomain.SERVER_API]: {
			subdomain: `${Server.E_ProxySubdomain.SERVER_API}.${
				config[CONFIG_VARIABLE.SERVER_CADDY_HOST]
			}`,
			to: `localhost:${
				config[CONFIG_VARIABLE.SERVER_CADDY_PORT]
			}/${Server.E_SERVER_API_ROUTE.BUNDLE_SCRIPTS}`,
			name: "Server API",
		},
	};
}

async function startCaddyServer(
	caddyRoutes: Record<Server.E_ProxySubdomain, ProxyConfig>,
	debugMode: boolean,
) {
	const caddyManager = CaddyManager.getInstance();

	try {
		await caddyManager.setupAndStart({
			proxyConfigs: caddyRoutes,
			debug: debugMode,
		});
		log({
			message: "Caddy routes are setup and running correctly.",
			type: "info",
		});
	} catch (error) {
		log({
			message: `Failed to setup and start Caddy: ${error}`,
			type: "error",
		});
		process.exit(1); // Use process.exit instead of Deno.exit
	}

	log({ message: "Caddy routes and their endpoints:", type: "success" });

	for (const route of Object.values(caddyRoutes)) {
		log({
			message: `${route.name}: ${config[CONFIG_VARIABLE.SERVER_CADDY_HOST]}:${
				config[CONFIG_VARIABLE.SERVER_CADDY_PORT]
			} -> ${route.subdomain} -> ${route.to}`,
			type: "success",
		});
	}
}

async function startBunServer(debugMode: boolean) {
	log({ message: "Starting Bun HTTP server", type: "info" });

	const host = config[CONFIG_VARIABLE.SERVER_HOST];
	const port = config[CONFIG_VARIABLE.SERVER_PORT];

	// Constants for bundling
	const BUNDLE_TIMEOUT = 60000; // 60 seconds
	const MAX_URLS = 50; // Maximum number of URLs to process

	const server = Bun.serve({
		port,
		hostname: host,
		development: debugMode,
		fetch: async (req) => {
			const url = new URL(req.url);

			// Basic routing
			switch (url.pathname) {
				case `/${Server.E_SERVER_API_ROUTE.BUNDLE_SCRIPTS}`:
					try {
						const { script_urls, script_raw } =
							Server.S_SERVER_API_REQUEST_BUNDLE_SCRIPTS.parse(
								await req.json(),
							);

						if (!Array.isArray(script_urls)) {
							return new Response(
								JSON.stringify(
									Server.S_SERVER_API_RESPONSE_BUNDLE_SCRIPTS.parse({
										error: "URLs must be provided as an array",
									}),
								),
								{
									status: 400,
									headers: {
										"Content-Type": "application/json",
									},
								},
							);
						}

						if (script_urls.length > MAX_URLS) {
							return new Response(
								JSON.stringify(
									Server.S_SERVER_API_RESPONSE_BUNDLE_SCRIPTS.parse({
										error: `Cannot process more than ${MAX_URLS} URLs at once`,
									}),
								),
								{
									status: 400,
									headers: {
										"Content-Type": "application/json",
									},
								},
							);
						}

						const compiledScripts = await Promise.all(
							script_urls.map(async (url: string) => {
								try {
									const timeoutPromise = new Promise((_, reject) => {
										setTimeout(
											() => reject(new Error(`Bundling timed out for ${url}`)),
											BUNDLE_TIMEOUT,
										);
									});

									const bundlePromise = build({
										entrypoints: [url],
										target: "browser",
									});

									const result = await Promise.race([
										bundlePromise,
										timeoutPromise,
									]);

									return {
										url,
										code: result.outputs[0].code,
										size: result.outputs[0].code.length,
									};
								} catch (error) {
									console.error(`Error bundling script ${url}:`, error);
									return {
										url,
										error: `Bundling error: ${error.message}`,
										stack: debugMode ? error.stack : undefined,
									};
								}
							}),
						);

						return new Response(
							JSON.stringify(
								Server.S_SERVER_API_RESPONSE_BUNDLE_SCRIPTS.parse({
									scripts: compiledScripts,
									timestamp: new Date().toISOString(),
								}),
							),
							{
								headers: {
									"Content-Type": "application/json",
									"Cache-Control": "public, max-age=3600",
								},
							},
						);
					} catch (error) {
						console.error("Server error:", error);
						return new Response(
							JSON.stringify(
								Server.S_SERVER_API_RESPONSE_BUNDLE_SCRIPTS.parse({
									error: error.message,
								}),
							),
							{
								status: 500,
								headers: { "Content-Type": "application/json" },
							},
						);
					}
				default:
					return new Response("Not Found", { status: 404 });
			}
		},
	});

	log({
		message: `Bun HTTP server running at http://${host}:${port}`,
		type: "success",
	});
}

await init();

export function loadConfig(): {
	[CONFIG_VARIABLE.SERVER_DEBUG]: boolean;
	[CONFIG_VARIABLE.SERVER_CADDY_HOST]: string;
	[CONFIG_VARIABLE.SERVER_CADDY_PORT]: number;
	[CONFIG_VARIABLE.SERVER_PORT]: number;
	[CONFIG_VARIABLE.SERVER_HOST]: string;
	[CONFIG_VARIABLE.FORCE_RESTART_SUPABASE]: boolean;
} {
	// Bun automatically loads .env files in this order:
	// 1. .env
	// 2. .env.production or .env.development (based on NODE_ENV)
	// 3. .env.local
	// So we don't need to explicitly load them

	// Parse command-line arguments using Bun's CLI parser
	const args = parseArgs({
		args: process.argv.slice(2),
		options: {
			debug: { type: "boolean" },
			caddyHost: { type: "string" },
			caddyPort: { type: "string" },
			serverPort: { type: "string" },
			serverHost: { type: "string" },
		},
	});

	// You can access env variables directly through process.env or Bun.env
	const debugMode =
		process.env[CONFIG_VARIABLE.SERVER_DEBUG] === "true" ||
		args.values.debug === true ||
		false;
	const caddyHost =
		process.env[CONFIG_VARIABLE.SERVER_CADDY_HOST] ||
		args.values.caddyHost ||
		"localhost";
	const caddyPort = Number.parseInt(
		process.env[CONFIG_VARIABLE.SERVER_CADDY_PORT] ||
			args.values.caddyPort?.toString() ||
			"3010",
	);
	const serverPort = Number.parseInt(
		process.env[CONFIG_VARIABLE.SERVER_PORT] ||
			args.values.serverPort?.toString() ||
			"3020",
	);
	const serverHost =
		process.env[CONFIG_VARIABLE.SERVER_HOST] ||
		args.values.serverHost ||
		"localhost";
	const forceRestartSupabase =
		process.env[CONFIG_VARIABLE.FORCE_RESTART_SUPABASE] === "true" || false;

	return {
		[CONFIG_VARIABLE.SERVER_DEBUG]: debugMode,
		[CONFIG_VARIABLE.SERVER_CADDY_HOST]: caddyHost,
		[CONFIG_VARIABLE.SERVER_CADDY_PORT]: caddyPort,
		[CONFIG_VARIABLE.SERVER_PORT]: serverPort,
		[CONFIG_VARIABLE.SERVER_HOST]: serverHost,
		[CONFIG_VARIABLE.FORCE_RESTART_SUPABASE]: forceRestartSupabase,
	};
}
