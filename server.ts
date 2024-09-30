import { parseArgs } from "jsr:@std/cli";
import { load } from "jsr:@std/dotenv";
import { CaddyManager, ProxyConfig } from "./modules/caddy/caddy_manager.ts";
import { log } from "./modules/general/log.ts";
import { Supabase } from "./modules/supabase/supabase_manager.ts";
import { Server } from "./modules/vircadia-world-meta/typescript/meta.ts";

// TODO:(@digisomni)
/*
 * we need to make Caddy issue certs for us automatically, OR allow for a custom CA to be used.
 */

const ENVIRONMENT_PREFIX = "VIRCADIA_WORLD";
const ENVIRONMENT_SERVER_PREFIX = "SERVER";

export enum CONFIG_VARIABLE {
    SERVER_DEBUG = `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_DEBUG`,
    SERVER_CADDY_HOST =
        `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_CADDY_HOST`,
    SERVER_CADDY_PORT =
        `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_CADDY_PORT`,
    FORCE_RESTART_SUPABASE =
        `${ENVIRONMENT_PREFIX}_${ENVIRONMENT_SERVER_PREFIX}_FORCE_RESTART_SUPABASE`,
}

const config = loadConfig();

async function init() {
    const debugMode = config[CONFIG_VARIABLE.SERVER_DEBUG];

    if (debugMode) {
        log({ message: "Server debug mode enabled", type: "info" });
    }

    log({ message: "Starting Vircadia World Server", type: "info" });

    await startSupabase(debugMode);
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
            Deno.exit(1);
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
        Deno.exit(1);
    }

    log({ message: "Caddy routes and their endpoints:", type: "success" });

    for (const route of Object.values(caddyRoutes)) {
        log({
            message: `${route.name}: ${
                config[CONFIG_VARIABLE.SERVER_CADDY_HOST]
            }:${
                config[
                    CONFIG_VARIABLE.SERVER_CADDY_PORT
                ]
            } -> ${route.subdomain} -> ${route.to}`,
            type: "success",
        });
    }
}

await init();

export function loadConfig(): {
    [CONFIG_VARIABLE.SERVER_DEBUG]: boolean;
    [CONFIG_VARIABLE.SERVER_CADDY_HOST]: string;
    [CONFIG_VARIABLE.SERVER_CADDY_PORT]: number;
    [CONFIG_VARIABLE.FORCE_RESTART_SUPABASE]: boolean;
} {
    // Load .env file
    load({ export: true });

    // Parse command-line arguments
    const args = parseArgs(Deno.args);

    const debugMode = Deno.env.get(CONFIG_VARIABLE.SERVER_DEBUG) === "true" ||
        args.debug === true ||
        false;
    const caddyHost = Deno.env.get(CONFIG_VARIABLE.SERVER_CADDY_HOST) ||
        args.caddyHost ||
        "localhost";
    const caddyPort = parseInt(
        Deno.env.get(CONFIG_VARIABLE.SERVER_CADDY_PORT) ||
            args.caddyPort ||
            "3010",
    );
    const forceRestartSupabase =
        Deno.env.get(CONFIG_VARIABLE.FORCE_RESTART_SUPABASE) === "true" ||
        false;
    return {
        [CONFIG_VARIABLE.SERVER_DEBUG]: debugMode,
        [CONFIG_VARIABLE.SERVER_CADDY_HOST]: caddyHost,
        [CONFIG_VARIABLE.SERVER_CADDY_PORT]: caddyPort,
        [CONFIG_VARIABLE.FORCE_RESTART_SUPABASE]: forceRestartSupabase,
    };
}
