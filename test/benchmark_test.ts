import { createClient } from "jsr:@supabase/supabase-js";
import { Supabase } from "../modules/supabase/supabase_manager.ts";

const SEED_COUNT = 10000; // Number of world_gltf entries to seed
const UPDATE_COUNT = 1000; // Number of updates to perform

function generateRandomWorldGLTF() {
    return {
        name: `World ${crypto.randomUUID()}`,
        version: "1.0.0",
        metadata: { description: "A test world" },
        asset: { version: "2.0" },
        extras: {
            vircadia: {
                name: `Vircadia World ${crypto.randomUUID()}`,
                uuid: crypto.randomUUID(),
                version: "1.0.0",
                createdAt: new Date().toISOString(),
                updatedAt: new Date().toISOString(),
                babylonjs: {
                    // Add any required BabylonJS properties here
                },
            },
        },
    };
}

Deno.test("Supabase DB Benchmark", async () => {
    console.log("Starting Supabase DB Benchmark test");

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

    // Seed the database
    console.log(`Seeding ${SEED_COUNT} world_gltf entries...`);
    const seedStart = performance.now();
    const seedData = Array.from(
        { length: SEED_COUNT },
        generateRandomWorldGLTF,
    );
    const { data: seededData, error: seedError } = await client
        .from("world_gltf")
        .insert(seedData)
        .select();
    if (seedError) {
        console.error("Error seeding data:", seedError);
        return;
    }
    const seedEnd = performance.now();
    console.log(`Seeding completed in ${seedEnd - seedStart}ms`);

    // Set up real-time subscription
    console.log("Setting up real-time subscription...");
    const channel = client
        .channel("world_gltf_changes")
        .on("postgres_changes", {
            event: "UPDATE",
            schema: "public",
            table: "world_gltf",
        }, (payload) => {
            console.log("Change received:", payload);
        })
        .subscribe();

    // Perform updates and measure time
    console.log(`Performing ${UPDATE_COUNT} updates...`);
    const updateStart = performance.now();
    let updateCount = 0;
    for (let i = 0; i < UPDATE_COUNT; i++) {
        const randomIndex = Math.floor(Math.random() * seededData.length);
        const worldToUpdate = seededData[randomIndex];
        const { data, error } = await client
            .from("world_gltf")
            .update({ name: `Updated World ${i}` })
            .eq("vircadia_uuid", worldToUpdate.vircadia_uuid);
        if (!error) updateCount++;
    }
    const updateEnd = performance.now();
    console.log(`Updates completed in ${updateEnd - updateStart}ms`);
    console.log(`Successfully updated ${updateCount} entries`);

    // Clean up
    await channel.unsubscribe();

    console.log("Cleaning up seeded data...");
    const { error: cleanupError } = await client
        .from("world_gltf")
        .delete()
        .in("vircadia_uuid", seededData.map((world) => world.vircadia_uuid));
    if (cleanupError) {
        console.error("Error cleaning up data:", cleanupError);
    } else {
        console.log("Cleanup completed");
    }

    console.log("Supabase DB Benchmark test completed");
});
