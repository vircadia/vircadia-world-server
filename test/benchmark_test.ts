import * as SupabaseTypes from "jsr:@supabase/supabase-js";
import { createClient } from "jsr:@supabase/supabase-js";
import { Supabase } from "../modules/supabase/supabase_manager.ts";

// Constants
const TEST_PREFIX = "ENHANCED_TEST_";
const UPDATE_RATE = 20; // updates per second
const TEST_DURATION = 60; // seconds

// Utility functions
function shuffleArray<T>(array: T[]): T[] {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}

// Test-specific interfaces
interface TestResults {
    totalOperations: number;
    operationsPerSecond: number;
    latencies: number[];
    minLatency: number;
    maxLatency: number;
    avgLatency: number;
}

// Object creation functions
async function createNode(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
    name: string,
): Promise<string> {
    const { data, error } = await client.from("nodes").insert({
        vircadia_world_uuid: worldId,
        name: `${TEST_PREFIX}${name}`,
        translation: [
            Math.random() * 1000,
            Math.random() * 1000,
            Math.random() * 1000,
        ],
        rotation: [Math.random(), Math.random(), Math.random(), 1],
        scale: [1, 1, 1],
    }).select("vircadia_uuid").single();

    if (error) throw error;
    return data.vircadia_uuid;
}

async function createVehicle(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
    index: number,
): Promise<string> {
    const nodeId = await createNode(client, worldId, `vehicle_${index}`);
    await client.rpc("create_node_metadata", {
        p_node_id: nodeId,
        p_key: "object_type",
        p_value_text: "vehicle",
    });
    await client.rpc("create_node_metadata", {
        p_node_id: nodeId,
        p_key: "max_speed",
        p_value_numeric: 100 + Math.random() * 50,
    });
    return nodeId;
}

async function createPedestrian(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
    index: number,
): Promise<string> {
    const nodeId = await createNode(client, worldId, `pedestrian_${index}`);
    await client.rpc("create_node_metadata", {
        p_node_id: nodeId,
        p_key: "object_type",
        p_value_text: "pedestrian",
    });
    await client.rpc("create_node_metadata", {
        p_node_id: nodeId,
        p_key: "walking_speed",
        p_value_numeric: 3 + Math.random() * 2,
    });
    return nodeId;
}

async function createEnvironmentObject(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
    index: number,
): Promise<string> {
    const nodeId = await createNode(client, worldId, `env_object_${index}`);
    await client.rpc("create_node_metadata", {
        p_node_id: nodeId,
        p_key: "object_type",
        p_value_text: "environment",
    });
    await client.rpc("create_node_metadata", {
        p_node_id: nodeId,
        p_key: "interactive",
        p_value_boolean: Math.random() > 0.5,
    });
    return nodeId;
}

// Test functions
async function runVehicleTest(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
): Promise<TestResults> {
    console.log("Running Vehicle Test...");
    const NUM_VEHICLES = 20;
    const PLAYERS_PER_VEHICLE = 2;
    const vehicles: string[] = [];
    const players: string[] = [];

    // Create vehicles and players
    for (let i = 0; i < NUM_VEHICLES; i++) {
        const vehicleId = await createVehicle(client, worldId, i);
        vehicles.push(vehicleId);
        for (let j = 0; j < PLAYERS_PER_VEHICLE; j++) {
            const playerId = await createPedestrian(
                client,
                worldId,
                i * PLAYERS_PER_VEHICLE + j,
            );
            players.push(playerId);
        }
    }

    const startTime = performance.now();
    const latencies: number[] = [];
    let totalOperations = 0;

    while (performance.now() - startTime < TEST_DURATION * 1000) {
        const updateStartTime = performance.now();

        // Update vehicles and players
        const updates = vehicles.map((vehicleId) => ({
            vircadia_uuid: vehicleId,
            vircadia_world_uuid: worldId,
            translation: [
                Math.random() * 1000,
                Math.random() * 1000,
                Math.random() * 1000,
            ],
            rotation: [Math.random(), Math.random(), Math.random(), 1],
        })).concat(players.map((playerId) => ({
            vircadia_uuid: playerId,
            vircadia_world_uuid: worldId,
            translation: [Math.random(), Math.random(), Math.random()],
            rotation: [Math.random(), Math.random(), Math.random(), 1],
        })));

        totalOperations += updates.length;

        const { error } = await client.from("nodes").upsert(updates);
        if (error) {
            console.error("Error updating nodes:", error);
        }

        const updateEndTime = performance.now();
        latencies.push(updateEndTime - updateStartTime);

        await new Promise((resolve) => setTimeout(resolve, 1000 / UPDATE_RATE));
    }

    const endTime = performance.now();
    const totalDuration = (endTime - startTime) / 1000; // in seconds
    const operationsPerSecond = totalOperations / totalDuration;

    return {
        totalOperations,
        operationsPerSecond,
        latencies,
        minLatency: Math.min(...latencies),
        maxLatency: Math.max(...latencies),
        avgLatency: latencies.reduce((sum, lat) => sum + lat, 0) /
            latencies.length,
    };
}

async function runPedestrianTest(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
): Promise<TestResults> {
    console.log("Running Pedestrian Test...");
    const NUM_PEDESTRIANS = 400;
    const ITEMS_PER_PEDESTRIAN = 5;
    const pedestrians: string[] = [];
    const items: string[] = [];

    // Create pedestrians and their items
    for (let i = 0; i < NUM_PEDESTRIANS; i++) {
        const pedestrianId = await createPedestrian(client, worldId, i);
        pedestrians.push(pedestrianId);
        for (let j = 0; j < ITEMS_PER_PEDESTRIAN; j++) {
            const itemId = await createEnvironmentObject(
                client,
                worldId,
                i * ITEMS_PER_PEDESTRIAN + j,
            );
            items.push(itemId);
        }
    }

    const startTime = performance.now();
    const latencies: number[] = [];
    let totalOperations = 0;

    while (performance.now() - startTime < TEST_DURATION * 1000) {
        const updateStartTime = performance.now();

        // Update pedestrians and items
        const updates = pedestrians.map((pedestrianId) => ({
            vircadia_uuid: pedestrianId,
            vircadia_world_uuid: worldId,
            translation: [
                Math.random() * 1000,
                Math.random() * 1000,
                Math.random() * 1000,
            ],
        })).concat(items.map((itemId) => ({
            vircadia_uuid: itemId,
            vircadia_world_uuid: worldId,
            translation: [Math.random(), Math.random(), Math.random()],
            rotation: [Math.random(), Math.random(), Math.random(), 1],
        })));

        totalOperations += updates.length;

        const { error } = await client.from("nodes").upsert(updates);
        if (error) {
            console.error("Error updating nodes:", error);
        }

        const updateEndTime = performance.now();
        latencies.push(updateEndTime - updateStartTime);

        await new Promise((resolve) => setTimeout(resolve, 1000 / UPDATE_RATE));
    }

    const endTime = performance.now();
    const totalDuration = (endTime - startTime) / 1000; // in seconds
    const operationsPerSecond = totalOperations / totalDuration;

    return {
        totalOperations,
        operationsPerSecond,
        latencies,
        minLatency: Math.min(...latencies),
        maxLatency: Math.max(...latencies),
        avgLatency: latencies.reduce((sum, lat) => sum + lat, 0) /
            latencies.length,
    };
}

async function runEnvironmentTest(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
): Promise<TestResults> {
    console.log("Running Environment Test...");
    const NUM_ENVIRONMENT_OBJECTS = 2000;
    const environmentObjects: string[] = [];

    // Create environment objects
    for (let i = 0; i < NUM_ENVIRONMENT_OBJECTS; i++) {
        const objectId = await createEnvironmentObject(client, worldId, i);
        environmentObjects.push(objectId);
    }

    const startTime = performance.now();
    const latencies: number[] = [];
    let totalOperations = 0;

    while (performance.now() - startTime < TEST_DURATION * 1000) {
        const updateStartTime = performance.now();

        // Update a subset of environment objects
        const objectsToUpdate = shuffleArray(environmentObjects).slice(0, 200); // Update 10% of objects
        const updates = objectsToUpdate.map((objectId) => ({
            vircadia_uuid: objectId,
            vircadia_world_uuid: worldId,
            translation: [
                Math.random() * 1000,
                Math.random() * 1000,
                Math.random() * 1000,
            ],
            rotation: [Math.random(), Math.random(), Math.random(), 1],
        }));

        totalOperations += updates.length;

        const { error } = await client.from("nodes").upsert(updates);
        if (error) {
            console.error("Error updating nodes:", error);
        }

        const updateEndTime = performance.now();
        latencies.push(updateEndTime - updateStartTime);

        await new Promise((resolve) => setTimeout(resolve, 1000 / UPDATE_RATE));
    }

    const endTime = performance.now();
    const totalDuration = (endTime - startTime) / 1000; // in seconds
    const operationsPerSecond = totalOperations / totalDuration;

    return {
        totalOperations,
        operationsPerSecond,
        latencies,
        minLatency: Math.min(...latencies),
        maxLatency: Math.max(...latencies),
        avgLatency: latencies.reduce((sum, lat) => sum + lat, 0) /
            latencies.length,
    };
}

async function runHolisticTest(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
): Promise<TestResults> {
    console.log("Running Holistic Test...");

    const vehicleResults = await runVehicleTest(client, worldId);
    const pedestrianResults = await runPedestrianTest(client, worldId);
    const environmentResults = await runEnvironmentTest(client, worldId);

    const totalOperations = vehicleResults.totalOperations +
        pedestrianResults.totalOperations + environmentResults.totalOperations;
    const totalDuration = TEST_DURATION * 3; // 3 tests, each running for TEST_DURATION
    const operationsPerSecond = totalOperations / totalDuration;
    const allLatencies = [
        ...vehicleResults.latencies,
        ...pedestrianResults.latencies,
        ...environmentResults.latencies,
    ];

    return {
        totalOperations,
        operationsPerSecond,
        latencies: allLatencies,
        minLatency: Math.min(...allLatencies),
        maxLatency: Math.max(...allLatencies),
        avgLatency: allLatencies.reduce((sum, lat) => sum + lat, 0) /
            allLatencies.length,
    };
}

// Result analysis and printing
function analyzeResults(results: TestResults): void {
    console.log(`Total operations: ${results.totalOperations}`);
    console.log(
        `Operations per second: ${results.operationsPerSecond.toFixed(2)}`,
    );
    console.log(`Min latency: ${results.minLatency.toFixed(2)} ms`);
    console.log(`Max latency: ${results.maxLatency.toFixed(2)} ms`);
    console.log(`Average latency: ${results.avgLatency.toFixed(2)} ms`);

    // Calculate percentiles
    const sortedLatencies = results.latencies.sort((a, b) => a - b);
    const percentiles = [50, 75, 90, 95, 99];
    for (const p of percentiles) {
        const index = Math.floor(sortedLatencies.length * p / 100);
        console.log(
            `${p}th percentile latency: ${
                sortedLatencies[index].toFixed(2)
            } ms`,
        );
    }
}

function printResults(
    vehicleResults: TestResults,
    pedestrianResults: TestResults,
    environmentResults: TestResults,
    holisticResults: TestResults,
): void {
    console.log("\nEnhanced Supabase MMO Realtime DB Benchmark Results:");
    console.log("\nVehicle Test Results:");
    analyzeResults(vehicleResults);
    console.log("\nPedestrian Test Results:");
    analyzeResults(pedestrianResults);
    console.log("\nEnvironment Test Results:");
    analyzeResults(environmentResults);
    console.log("\nHolistic Test Results:");
    analyzeResults(holisticResults);
}

// Main benchmark function
async function runEnhancedBenchmark(
    client: SupabaseTypes.SupabaseClient,
): Promise<void> {
    const { data: worldData, error: worldError } = await client.from(
        "world_gltf",
    ).insert({
        name: `${TEST_PREFIX}Benchmark World`,
        version: "1.0.0",
        metadata: { description: "A world for enhanced benchmark testing" },
        asset: { version: "2.0" },
    }).select().single();

    if (worldError || !worldData) {
        throw new Error(`Error creating test world: ${worldError?.message}`);
    }

    const worldId = worldData.vircadia_uuid;

    const vehicleResults = await runVehicleTest(client, worldId);
    const pedestrianResults = await runPedestrianTest(client, worldId);
    const environmentResults = await runEnvironmentTest(client, worldId);
    const holisticResults = await runHolisticTest(client, worldId);

    printResults(
        vehicleResults,
        pedestrianResults,
        environmentResults,
        holisticResults,
    );

    // Clean up
    await client.from("nodes").delete().like("name", `${TEST_PREFIX}%`);
    await client.from("world_gltf").delete().eq("vircadia_uuid", worldId);
}

// Main test function
Deno.test("Enhanced Supabase MMO Realtime DB Benchmark", async () => {
    console.log("Starting Enhanced Supabase MMO Realtime DB Benchmark test");

    // Initialize Supabase
    console.log("Initializing Supabase...");
    const supabase = Supabase.getInstance(true); // Enable debug mode
    await supabase.initializeAndStart({ forceRestart: false });
    console.log("Supabase initialized successfully");

    // Get Supabase status
    console.log("Getting Supabase status...");
    const status = await supabase.getStatus();
    console.log("Supabase status:", status);

    // Create Supabase client
    console.log("Creating Supabase client...");
    const supabaseUrl = `http://${status.api.host}:${status.api.port}`;
    const supabaseKey = status.anonKey || "";
    const client = createClient(supabaseUrl, supabaseKey);
    console.log("Supabase client created successfully");

    // Sign in with the test user
    console.log("Signing in with test user...");
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

    try {
        await runEnhancedBenchmark(client);
    } catch (error) {
        console.error("Test failed:", error.message);
    } finally {
        // Clean up resources
        console.log("Cleaning up resources...");
        await client.auth.signOut();
        console.log("Signed out and cleaned up resources");
    }

    console.log("Enhanced Supabase MMO Realtime DB Benchmark test completed");
});
