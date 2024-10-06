import * as SupabaseTypes from "jsr:@supabase/supabase-js";
import { createClient } from "jsr:@supabase/supabase-js";
import { log } from "../modules/general/log.ts";
import { Supabase } from "../modules/supabase/supabase_manager.ts";
import { World } from "../modules/vircadia-world-meta/typescript/meta.ts";

// Constants
const TEST_NAME = "Vircadia World Realtime Benchmark";
const TEST_PREFIX = "REALTIME_BENCHMARK_TEST_";
const UPDATE_RATE = 60; // updates per second
const TEST_DURATION = 10; // seconds

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
    const { data, error } = await client.from(World.E_Table.NODES).insert({
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
    log({ message: "Running Vehicle Test...", type: "info" });
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
        log({
            message: `Created vehicle ${i + 1}/${NUM_VEHICLES}`,
            type: "debug",
        });
    }

    const startTime = performance.now();
    const latencies: number[] = [];
    let totalOperations = 0;
    let updateCount = 0;

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

        const { error } = await client.from(World.E_Table.NODES).upsert(
            updates,
        );
        if (error) {
            log({ message: `Error updating nodes: ${error}`, type: "error" });
        }

        const updateEndTime = performance.now();
        latencies.push(updateEndTime - updateStartTime);

        updateCount++;
        log({
            message: `Vehicle Test: Update ${updateCount} / ${
                UPDATE_RATE * TEST_DURATION
            }`,
            type: "debug",
        });

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
    log({ message: "Running Pedestrian Test...", type: "info" });
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
        log({
            message: `Created pedestrian ${i + 1}/${NUM_PEDESTRIANS}`,
            type: "debug",
        });
    }

    const startTime = performance.now();
    const latencies: number[] = [];
    let totalOperations = 0;
    let updateCount = 0;

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

        const { error } = await client.from(World.E_Table.NODES).upsert(
            updates,
        );
        if (error) {
            log({ message: `Error updating nodes: ${error}`, type: "error" });
        }

        const updateEndTime = performance.now();
        latencies.push(updateEndTime - updateStartTime);

        updateCount++;
        log({
            message: `Pedestrian Test: Update ${updateCount} / ${
                UPDATE_RATE * TEST_DURATION
            }`,
            type: "debug",
        });

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
    log({ message: "Running Environment Test...", type: "info" });
    const NUM_ENVIRONMENT_OBJECTS = 2000;
    const environmentObjects: string[] = [];

    // Create environment objects
    for (let i = 0; i < NUM_ENVIRONMENT_OBJECTS; i++) {
        const objectId = await createEnvironmentObject(client, worldId, i);
        environmentObjects.push(objectId);
        if ((i + 1) % 100 === 0) {
            log({
                message: `Created environment object ${
                    i + 1
                }/${NUM_ENVIRONMENT_OBJECTS}`,
                type: "debug",
            });
        }
    }

    const startTime = performance.now();
    const latencies: number[] = [];
    let totalOperations = 0;
    let updateCount = 0;

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

        const { error } = await client.from(World.E_Table.NODES).upsert(
            updates,
        );
        if (error) {
            log({ message: `Error updating nodes: ${error}`, type: "error" });
        }

        const updateEndTime = performance.now();
        latencies.push(updateEndTime - updateStartTime);

        updateCount++;
        log({
            message: `Environment Test: Update ${updateCount} / ${
                UPDATE_RATE * TEST_DURATION
            }`,
            type: "debug",
        });

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

async function runParallelTest(
    client: SupabaseTypes.SupabaseClient,
    worldId: string,
): Promise<TestResults> {
    log({ message: "Running Parallel Test...", type: "info" });

    const [vehicleResults, pedestrianResults, environmentResults] =
        await Promise.all([
            runVehicleTest(client, worldId),
            runPedestrianTest(client, worldId),
            runEnvironmentTest(client, worldId),
        ]);

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
    log({
        message: `Total operations: ${results.totalOperations}`,
        type: "info",
    });
    log({
        message: `Operations per second: ${
            results.operationsPerSecond.toFixed(2)
        }`,
        type: "info",
    });
    log({
        message: `Min latency: ${results.minLatency.toFixed(2)} ms`,
        type: "info",
    });
    log({
        message: `Max latency: ${results.maxLatency.toFixed(2)} ms`,
        type: "info",
    });
    log({
        message: `Average latency: ${results.avgLatency.toFixed(2)} ms`,
        type: "info",
    });

    // Calculate percentiles
    const sortedLatencies = results.latencies.sort((a, b) => a - b);
    const percentiles = [50, 75, 90, 95, 99];
    for (const p of percentiles) {
        const index = Math.floor(sortedLatencies.length * p / 100);
        log({
            message: `${p}th percentile latency: ${
                sortedLatencies[index].toFixed(2)
            } ms`,
            type: "info",
        });
    }
}

function printResults(
    vehicleResults: TestResults,
    pedestrianResults: TestResults,
    environmentResults: TestResults,
    parallelResults: TestResults,
): void {
    log({
        message: `\n----------\n----------\n----------\n----------`,
        type: "success",
    });
    log({
        message: "\n${TEST_NAME} Results:",
        type: "success",
    });
    log({ message: "\nVehicle Test Results:", type: "success" });
    analyzeResults(vehicleResults);
    log({ message: "\nPedestrian Test Results:", type: "success" });
    analyzeResults(pedestrianResults);
    log({ message: "\nEnvironment Test Results:", type: "success" });
    analyzeResults(environmentResults);
    log({ message: "\nParallel Test Results:", type: "success" });
    analyzeResults(parallelResults);
}

// Cleanup function
async function cleanupTestData(
    client: SupabaseTypes.SupabaseClient,
): Promise<void> {
    log({ message: "Cleaning up test data...", type: "info" });

    // Delete all nodes with names starting with TEST_PREFIX
    await client.from(World.E_Table.NODES).delete().like(
        "name",
        `${TEST_PREFIX}%`,
    );

    // Delete all worlds with names starting with TEST_PREFIX
    await client.from(World.E_Table.WORLD_GLTF).delete().like(
        "name",
        `${TEST_PREFIX}%`,
    );

    log({ message: "Cleanup completed", type: "success" });
}

// Main benchmark function
async function runBenchmark(
    client: SupabaseTypes.SupabaseClient,
): Promise<void> {
    const { data: worldData, error: worldError } = await client.from(
        World.E_Table.WORLD_GLTF,
    ).insert({
        name: `${TEST_PREFIX}World`,
        version: "1.0.0",
        metadata: { description: "A world for benchmark testing" },
        asset: { version: "2.0" },
    }).select().single();

    if (worldError || !worldData) {
        throw new Error(`Error creating test world: ${worldError?.message}`);
    }

    const worldId = worldData.vircadia_uuid;

    const vehicleResults = await runVehicleTest(client, worldId);
    const pedestrianResults = await runPedestrianTest(client, worldId);
    const environmentResults = await runEnvironmentTest(client, worldId);
    const parallelResults = await runParallelTest(client, worldId);

    printResults(
        vehicleResults,
        pedestrianResults,
        environmentResults,
        parallelResults,
    );
}

// Main test function
Deno.test(TEST_NAME, async () => {
    log({
        message: `Starting ${TEST_NAME}`,
        type: "info",
    });

    // Initialize Supabase
    log({ message: "Initializing Supabase...", type: "info" });
    const supabase = Supabase.getInstance(true); // Enable debug mode
    await supabase.initializeAndStart({ forceRestart: false });
    log({ message: "Supabase initialized successfully", type: "success" });

    // Get Supabase status
    log({ message: "Getting Supabase status...", type: "info" });
    const status = await supabase.getStatus();
    log({
        message: `Supabase status: ${JSON.stringify(status)}`,
        type: "info",
    });

    // Create Supabase client
    log({ message: "Creating Supabase client...", type: "info" });
    const supabaseUrl = `http://${status.api.host}:${status.api.port}`;
    const supabaseKey = status.anonKey || "";
    const client = createClient(supabaseUrl, supabaseKey);
    log({ message: "Supabase client created successfully", type: "success" });

    // Sign in with the test user
    log({ message: "Signing in with test user...", type: "info" });
    const testUserEmail = Deno.env.get("TEST_USER_EMAIL");
    const testUserPassword = Deno.env.get("TEST_USER_PASSWORD");
    if (!testUserEmail || !testUserPassword) {
        log({
            message:
                "TEST_USER_EMAIL or TEST_USER_PASSWORD environment variable is not set.",
            type: "error",
        });
        return;
    }

    const { error: authError } = await client.auth.signInWithPassword({
        email: testUserEmail,
        password: testUserPassword,
    });

    if (authError) {
        log({ message: `Error signing in: ${authError}`, type: "error" });
        return;
    }
    log({ message: "Signed in as test user successfully", type: "success" });

    try {
        // Clean up any existing test data before starting
        await cleanupTestData(client);

        // Run the benchmark
        await runBenchmark(client);
    } catch (error) {
        log({ message: `Test failed: ${error.message}`, type: "error" });
    } finally {
        // Clean up resources and test data
        await cleanupTestData(client);
        log({ message: "Cleaning up resources...", type: "info" });
        await client.auth.signOut();
        log({
            message: "Signed out and cleaned up resources",
            type: "success",
        });
    }

    log({
        message: `${TEST_NAME} completed`,
        type: "success",
    });
});
