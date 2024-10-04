import * as SupabaseTypes from "jsr:@supabase/supabase-js";
import { createClient } from "jsr:@supabase/supabase-js";
import { Supabase } from "../modules/supabase/supabase_manager.ts";
import { World } from "../modules/vircadia-world-meta/typescript/meta.ts";

// Constants
const NUM_CLIENTS = 50;
const NUM_ZONES = 5;
const NODES_PER_ZONE = 50;
const ZONES_PER_CLIENT = 2;
const TEST_PREFIX = "INTERNAL_TEST_";
const MAX_RETRIES = 3;
const RETRY_DELAY = 1000; // milliseconds
const UPDATES_PER_CLIENT = 100;

// Calculate total number of nodes
const TOTAL_NODES = NUM_ZONES * NODES_PER_ZONE;

// Utility functions
function shuffleArray<T>(array: T[]): T[] {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}

// Node generation
function generateRandomNode(worldId: string, nodeIndex: number): World.I_Node {
    const nodeUuid = crypto.randomUUID();
    return {
        vircadia_uuid: nodeUuid,
        vircadia_world_uuid: worldId,
        name: `${TEST_PREFIX}node_${nodeIndex}`,
        translation: [
            Math.random() * 1000,
            Math.random() * 1000,
            Math.random() * 1000,
        ],
        rotation: [
            Math.random() * 360,
            Math.random() * 360,
            Math.random() * 360,
        ],
        scale: [1, 1, 1],
        vircadia_version: "1.0.0",
        vircadia_createdat: new Date().toISOString(),
        vircadia_updatedat: new Date().toISOString(),
        extras: {},
    };
}

// MMO Client class
class MMOClient {
    private supabase: SupabaseTypes.SupabaseClient;
    private clientId: number;
    private worldId: string;
    private subscribedNodes: string[];
    private positions: Map<string, [number, number, number]>;
    public latencies: number[] = [];
    private maxRetries = MAX_RETRIES;
    private retryDelay = RETRY_DELAY;

    constructor(
        supabase: SupabaseTypes.SupabaseClient,
        clientId: number,
        worldId: string,
        allNodes: World.I_Node[],
    ) {
        this.supabase = supabase;
        this.clientId = clientId;
        this.worldId = worldId;
        this.subscribedNodes = this.assignNodesToClient(allNodes);
        this.positions = new Map();

        // Initialize positions for subscribed nodes
        this.subscribedNodes.forEach((nodeUuid) => {
            this.positions.set(nodeUuid, [
                Math.random() * 1000,
                Math.random() * 1000,
                Math.random() * 1000,
            ]);
        });
    }

    private assignNodesToClient(allNodes: World.I_Node[]): string[] {
        const startIndex = this.clientId * NODES_PER_ZONE * ZONES_PER_CLIENT;
        return allNodes.slice(
            startIndex,
            startIndex + NODES_PER_ZONE * ZONES_PER_CLIENT,
        )
            .map((node) => node.vircadia_uuid);
    }

    private updateNode(nodeUuid: string): Partial<World.I_Node> {
        const currentPosition = this.positions.get(nodeUuid)!;
        const newPosition = currentPosition.map((coord) =>
            coord + (Math.random() - 0.5) * 2
        ) as [number, number, number];
        this.positions.set(nodeUuid, newPosition);

        return {
            vircadia_uuid: nodeUuid,
            vircadia_world_uuid: this.worldId,
            translation: newPosition,
            rotation: [
                Math.random() * 360,
                Math.random() * 360,
                Math.random() * 360,
            ],
            scale: [
                1 + Math.random() * 0.1,
                1 + Math.random() * 0.1,
                1 + Math.random() * 0.1,
            ],
            vircadia_updatedat: new Date().toISOString(),
        };
    }

    async update() {
        const updates = this.subscribedNodes.map((nodeUuid) =>
            this.updateNode(nodeUuid)
        );

        const startTime = performance.now();
        let error;
        for (let attempt = 0; attempt < this.maxRetries; attempt++) {
            try {
                const { error: updateError } = await this.supabase.from("nodes")
                    .upsert(updates);
                if (!updateError) {
                    error = null;
                    break;
                }
                error = updateError;
            } catch (e) {
                error = e;
            }
            if (attempt < this.maxRetries - 1) {
                await new Promise((resolve) =>
                    setTimeout(resolve, this.retryDelay * Math.pow(2, attempt))
                );
            }
        }
        if (error) {
            console.error(
                `Error updating nodes for client ${this.clientId}:`,
                error,
            );
        }
        const endTime = performance.now();
        this.latencies.push(endTime - startTime);
    }
}

// Modified client runner function
async function runClient(client: MMOClient, totalUpdates: number) {
    for (let i = 0; i < totalUpdates; i++) {
        await client.update();
    }
}

// Main benchmark test
Deno.test("Supabase MMO Realtime DB Benchmark", async () => {
    console.log("Starting Supabase MMO Realtime DB Benchmark test");

    // Initialize Supabase
    console.log("Step 1: Initializing Supabase...");
    const supabase = Supabase.getInstance(true); // Enable debug mode
    await supabase.initializeAndStart({ forceRestart: false });
    console.log("Supabase initialized successfully");

    // Get Supabase status
    console.log("\nStep 2: Getting Supabase status...");
    const status = await supabase.getStatus();
    console.log("Supabase status:", status);

    // Create Supabase client
    console.log("\nStep 3: Creating Supabase client...");
    const supabaseUrl = `http://${status.api.host}:${status.api.port}`;
    const supabaseKey = status.anonKey || "";
    const client = createClient(supabaseUrl, supabaseKey);
    console.log("Supabase client created successfully");

    // Sign in with the test user
    console.log("\nStep 4: Signing in with test user...");
    const testUserEmail = Deno.env.get("TEST_USER_EMAIL");
    const testUserPassword = Deno.env.get("TEST_USER_PASSWORD");
    if (!testUserEmail || !testUserPassword) {
        console.error(
            "TEST_USER_EMAIL or TEST_USER_PASSWORD environment variable is not set.",
        );
        return;
    }

    const { error: authError } = await client.auth.signInWithPassword({
        email: testUserEmail,
        password: testUserPassword,
    });

    if (authError) {
        console.error("Error signing in:", authError);
        return;
    }
    console.log("Signed in as test user successfully");

    let channel: SupabaseTypes.RealtimeChannel | null = null;

    try {
        // Create a test world
        console.log("\nStep 5: Creating test world...");
        const testWorldData: Partial<World.I_WorldGLTF> = {
            name: `${TEST_PREFIX}Benchmark World`,
            version: "1.0.0",
            metadata: { description: "A world for benchmark testing" },
            asset: { version: "2.0" },
            vircadia_version: "1.0.0",
            vircadia_createdat: new Date().toISOString(),
            vircadia_updatedat: new Date().toISOString(),
        };

        const { data: worldData, error: worldError } = await client
            .from("world_gltf")
            .insert(testWorldData)
            .select()
            .single();

        if (worldError || !worldData) {
            throw new Error(
                `Error creating test world: ${worldError?.message}`,
            );
        }
        console.log("Test world created successfully");

        const worldId = worldData.vircadia_uuid;

        // Create nodes for all zones
        console.log(`\nStep 6: Creating ${TOTAL_NODES} nodes...`);
        const nodes: World.I_Node[] = [];
        for (let nodeIndex = 0; nodeIndex < TOTAL_NODES; nodeIndex++) {
            nodes.push(generateRandomNode(worldId, nodeIndex));
        }
        const { error: nodesError } = await client.from("nodes").insert(nodes);
        if (nodesError) {
            throw new Error(`Error creating nodes: ${nodesError.message}`);
        }
        console.log(`${TOTAL_NODES} nodes created successfully`);

        // Set up real-time subscription
        console.log("\nStep 7: Setting up real-time subscription...");
        channel = client
            .channel("nodes_changes")
            .on("postgres_changes", {
                event: "UPDATE",
                schema: "public",
                table: "nodes",
            }, (payload) => {
                // We're not processing the updates, just measuring broadcast performance
            })
            .subscribe();
        console.log("Real-time subscription set up successfully");

        // Create and run clients
        console.log(
            `\nStep 8: Running ${NUM_CLIENTS} clients concurrently for ${UPDATES_PER_CLIENT} updates per client...`,
        );
        const clients = Array.from(
            { length: NUM_CLIENTS },
            (_, i) => new MMOClient(client, i, worldId, nodes),
        );

        const startTime = performance.now();
        await Promise.all(
            clients.map((client) => runClient(client, UPDATES_PER_CLIENT)),
        );
        const endTime = performance.now();
        console.log("All clients finished running");

        // Collect and analyze results
        console.log("\nStep 9: Collecting and analyzing results...");
        const totalDuration = (endTime - startTime) / 1000; // in seconds
        const totalUpdates = NUM_CLIENTS * UPDATES_PER_CLIENT;
        const updatesPerSecond = totalUpdates / totalDuration;

        const allLatencies = clients.flatMap((client) => client.latencies);

        if (totalUpdates === 0) {
            console.log(
                "No updates were recorded. Check for errors in the client update process.",
            );
            return;
        }

        const minLatency = Math.min(...allLatencies);
        const maxLatency = Math.max(...allLatencies);
        const avgLatency = allLatencies.reduce((sum, lat) => sum + lat, 0) /
            totalUpdates;
        const medianLatency = allLatencies.sort((a, b) =>
            a - b
        )[Math.floor(totalUpdates / 2)];

        // Calculate standard deviation
        const latencyVariance = allLatencies.reduce((sum, lat) =>
            sum + Math.pow(lat - avgLatency, 2), 0) / totalUpdates;
        const latencyStdDev = Math.sqrt(latencyVariance);

        // Calculate total operations
        const totalOperations = NUM_CLIENTS * UPDATES_PER_CLIENT *
            NODES_PER_ZONE * ZONES_PER_CLIENT;
        const operationsPerSecond = totalOperations / totalDuration;

        // Print results
        console.log("\nSupabase MMO Realtime DB Benchmark Results:");

        console.log("\nConfiguration:");
        console.log("------------------------------");
        console.log(`Number of clients:    ${NUM_CLIENTS}`);
        console.log(`Number of zones:      ${NUM_ZONES}`);
        console.log(`Nodes per zone:       ${NODES_PER_ZONE}`);
        console.log(`Zones per client:     ${ZONES_PER_CLIENT}`);
        console.log(`Total nodes:          ${TOTAL_NODES}`);
        console.log(`Updates per client:   ${UPDATES_PER_CLIENT}`);
        console.log(`Max retries:          ${MAX_RETRIES}`);
        console.log(`Retry delay:          ${RETRY_DELAY} ms`);

        console.log("\nBenchmark Results:");
        console.log("------------------------------");
        console.log(`Total updates:        ${totalUpdates}`);
        console.log(`Total operations:     ${totalOperations}`);
        console.log(
            `Total duration:       ${totalDuration.toFixed(2)} seconds`,
        );
        console.log(`Updates per second:   ${updatesPerSecond.toFixed(2)}`);
        console.log(`Operations per second: ${operationsPerSecond.toFixed(2)}`);
        console.log(`Min latency:          ${minLatency.toFixed(6)} ms`);
        console.log(`Max latency:          ${maxLatency.toFixed(6)} ms`);
        console.log(`Average latency:      ${avgLatency.toFixed(6)} ms`);
        console.log(`Median latency:       ${medianLatency.toFixed(6)} ms`);
        console.log(`Latency Std Dev:      ${latencyStdDev.toFixed(6)} ms`);

        // Calculate percentiles
        const percentiles = [50, 75, 90, 95, 99];
        for (const p of percentiles) {
            const index = Math.floor(totalUpdates * p / 100);
            if (index < allLatencies.length) {
                console.log(
                    `${p}th percentile latency: ${
                        allLatencies[index].toFixed(6)
                    } ms`,
                );
            } else {
                console.log(`${p}th percentile latency: N/A (not enough data)`);
            }
        }
    } catch (error) {
        console.error("Test failed:", error.message);
    } finally {
        // Clean up
        console.log("\nStep 10: Cleaning up test data...");
        await client.from("nodes").delete().like("name", `${TEST_PREFIX}%`);
        await client.from("world_gltf").delete().like(
            "name",
            `${TEST_PREFIX}%`,
        );
        console.log("Test data cleaned up successfully");

        // Cleanup resources
        console.log("\nStep 11: Cleaning up resources...");
        if (channel) {
            await channel.unsubscribe();
        }
        await client.removeAllChannels();
        client.realtime.disconnect();
        await client.auth.signOut();
        console.log("Signed out and cleaned up resources");
    }

    console.log("\nSupabase MMO Realtime DB Benchmark test completed");
});
