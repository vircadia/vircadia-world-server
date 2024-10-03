import * as SupabaseTypes from "jsr:@supabase/supabase-js";
import { createClient } from "jsr:@supabase/supabase-js";
import { Supabase } from "../modules/supabase/supabase_manager.ts";
import { World } from "../modules/vircadia-world-meta/typescript/meta.ts";

// Constants
const NUM_CLIENTS = 500;
const NUM_ZONES = 50;
const NODES_PER_ZONE = 10;
const ZONES_PER_CLIENT = 5;
const UPDATES_PER_SECOND = 30;
const BENCHMARK_DURATION = 60; // seconds
const TEST_PREFIX = "INTERNAL_TEST_";

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
function generateRandomNode(
    worldId: string,
    nodeIndex: number,
): World.I_Node {
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
        extras: {
            vircadia: {
                name: `Node ${nodeIndex}`,
                version: "1.0.0",
                createdAt: new Date(),
                updatedAt: new Date(),
            },
        },
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
        return shuffleArray(allNodes.map((node) => node.vircadia_uuid))
            .slice(0, NODES_PER_ZONE * ZONES_PER_CLIENT);
    }

    async update() {
        const updates = [];
        for (const [nodeUuid, position] of this.positions) {
            // Simulate movement
            const newPosition = position.map((coord) =>
                coord + (Math.random() - 0.5) * 10
            ) as [number, number, number];
            this.positions.set(nodeUuid, newPosition);

            updates.push({
                vircadia_uuid: nodeUuid,
                translation: newPosition,
                extras: {
                    vircadia: {
                        updatedAt: new Date().toISOString(),
                    },
                },
            });
        }

        const startTime = performance.now();
        const { error } = await this.supabase
            .from("nodes")
            .upsert(updates);
        const endTime = performance.now();

        if (!error) {
            this.latencies.push(endTime - startTime);
        }
    }
}

// Client runner function
async function runClient(client: MMOClient, duration: number) {
    const endTime = Date.now() + duration * 1000;
    while (Date.now() < endTime) {
        await client.update();
        await new Promise((resolve) =>
            setTimeout(resolve, 1000 / UPDATES_PER_SECOND)
        );
    }
}

// Main benchmark test
Deno.test("Supabase MMO Realtime DB Benchmark", async () => {
    console.log("Starting Supabase MMO Realtime DB Benchmark test");

    // Initialize Supabase
    console.log("Initializing Supabase...");
    const supabase = Supabase.getInstance(true); // Enable debug mode
    await supabase.initializeAndStart({ forceRestart: false });
    console.log("Supabase initialized");

    // Get Supabase status
    console.log("Getting Supabase status...");
    const status = await supabase.getStatus();
    console.log("Supabase status:", status);

    // Create Supabase client
    console.log("Creating Supabase client...");
    const supabaseUrl = `http://${status.api.host}:${status.api.port}`;
    const supabaseKey = status.anonKey || "";
    const client = createClient(supabaseUrl, supabaseKey);
    console.log("Supabase client created");

    // Sign in with the test user
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

    console.log("Signed in as test user");

    let channel: SupabaseTypes.RealtimeChannel | null = null;

    try {
        // Create a test world
        const { data: worldData, error: worldError } = await client
            .from("world_gltf")
            .insert({
                name: `${TEST_PREFIX}Benchmark World`,
                version: "1.0.0",
                metadata: { description: "A world for benchmark testing" },
                asset: { version: "2.0" },
            })
            .select()
            .single();

        if (worldError || !worldData) {
            throw new Error(
                `Error creating test world: ${worldError?.message}`,
            );
        }

        const worldId = worldData.vircadia_uuid;

        // Create nodes for all zones
        console.log(`Creating ${TOTAL_NODES} nodes...`);
        const nodes: World.I_Node[] = [];
        for (let nodeIndex = 0; nodeIndex < TOTAL_NODES; nodeIndex++) {
            nodes.push(generateRandomNode(worldId, nodeIndex));
        }
        const { error: nodesError } = await client.from("nodes").insert(nodes);
        if (nodesError) {
            throw new Error(`Error creating nodes: ${nodesError.message}`);
        }

        // Set up real-time subscription
        console.log("Setting up real-time subscription...");
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

        // Create and run clients
        console.log(
            `Running ${NUM_CLIENTS} clients for ${BENCHMARK_DURATION} seconds...`,
        );
        const clients = Array.from(
            { length: NUM_CLIENTS },
            (_, i) => new MMOClient(client, i, worldId, nodes),
        );
        const clientPromises = clients.map((client) =>
            runClient(client, BENCHMARK_DURATION)
        );

        // Wait for all clients to finish
        await Promise.all(clientPromises);

        // Collect and analyze results
        const allLatencies = clients.flatMap((client) => client.latencies);
        const totalUpdates = allLatencies.length;
        const minLatency = Math.min(...allLatencies);
        const maxLatency = Math.max(...allLatencies);
        const avgLatency = allLatencies.reduce((sum, lat) => sum + lat, 0) /
            totalUpdates;
        const medianLatency = allLatencies.sort((a, b) =>
            a - b
        )[Math.floor(totalUpdates / 2)];

        // Print results
        console.log("Supabase MMO Realtime DB Benchmark Results:");
        console.log(`Number of clients: ${NUM_CLIENTS}`);
        console.log(`Number of zones: ${NUM_ZONES}`);
        console.log(`Nodes per zone: ${NODES_PER_ZONE}`);
        console.log(`Zones per client: ${ZONES_PER_CLIENT}`);
        console.log(`Total nodes: ${TOTAL_NODES}`);
        console.log(`Updates per second per client: ${UPDATES_PER_SECOND}`);
        console.log(`Benchmark duration: ${BENCHMARK_DURATION} seconds`);
        console.log(`Total updates: ${totalUpdates}`);
        console.log(`Min latency: ${minLatency.toFixed(6)} ms`);
        console.log(`Max latency: ${maxLatency.toFixed(6)} ms`);
        console.log(`Average latency: ${avgLatency.toFixed(6)} ms`);
        console.log(`Median latency: ${medianLatency.toFixed(6)} ms`);

        // Calculate percentiles
        const percentiles = [50, 75, 90, 95, 99];
        for (const p of percentiles) {
            const index = Math.floor(totalUpdates * p / 100);
            console.log(
                `${p}th percentile latency: ${
                    allLatencies[index].toFixed(6)
                } ms`,
            );
        }
    } catch (error) {
        console.error("Test failed:", error.message);
    } finally {
        // Clean up
        console.log("Cleaning up test data...");
        await client.from("nodes").delete().like("name", `${TEST_PREFIX}%`);
        await client.from("world_gltf").delete().like(
            "name",
            `${TEST_PREFIX}%`,
        );

        // Cleanup resources
        if (channel) {
            await channel.unsubscribe();
        }
        await client.removeAllChannels();
        client.realtime.disconnect();
        await client.auth.signOut();
        console.log("Signed out and cleaned up resources");
    }

    console.log("Supabase MMO Realtime DB Benchmark test completed");
});
