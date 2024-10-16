import { assert } from "jsr:@std/assert";
import { Accessor, Document, NodeIO } from "npm:@gltf-transform/core";
import { dedup, prune } from "npm:@gltf-transform/functions";

Deno.test("glTF import, combine, and export test", async () => {
    // Create a new Document
    const document = new Document();
    const scene = document.createScene();

    // Create a root node
    const rootNode = document.createNode("Root");
    scene.addChild(rootNode);

    // Create and add an animation
    const animation = document.createAnimation("TestAnimation");
    const animationChannel = document.createAnimationChannel();
    const animationSampler = document.createAnimationSampler();
    animation.addChannel(animationChannel);
    animation.addSampler(animationSampler);
    animationChannel.setTargetNode(rootNode);
    animationChannel.setTargetPath("translation");

    // Create input accessor
    const inputAccessor = document.createAccessor("inputAccessor")
        .setArray(new Float32Array([0]))
        .setType(Accessor.Type.SCALAR);
    animationSampler.setInput(inputAccessor);

    // Create output accessor
    const outputAccessor = document.createAccessor("outputAccessor")
        .setArray(new Float32Array([0, 0, 0]))
        .setType(Accessor.Type.VEC3);
    animationSampler.setOutput(outputAccessor);

    // Create and add a camera
    const camera = document.createCamera("TestCamera");
    camera.setPerspective(45, 16 / 9, 0.1, 100);
    const cameraNode = document.createNode("CameraNode");
    cameraNode.setCamera(camera);
    rootNode.addChild(cameraNode);

    // Create and add a child node
    const childNode = document.createNode("ChildNode");
    rootNode.addChild(childNode);

    // Export the original document
    const io = new NodeIO();
    const originalGltf = await io.writeJSON(document);

    // Create a new document to combine elements
    const combinedDocument = new Document();
    combinedDocument.createScene();

    // Import elements from the original document
    await combinedDocument.import(document);

    // Optimize the combined document
    await combinedDocument.transform(
        prune(),
        dedup(),
    );

    // Export the combined document
    const combinedGltf = await io.writeJSON(combinedDocument);

    // Add the missing asset property if it's not present
    if (!combinedGltf.json.asset) {
        combinedGltf.json.asset = { version: "2.0" };
    }

    // Verify the combined glTF
    const importedCombined = await io.readJSON({
        json: {
            ...combinedGltf.json,
        },
        resources: combinedGltf.resources,
    });

    // Check if all elements are present in the combined glTF
    assert(
        importedCombined.getRoot().listAnimations().length === 1,
        "Animation should be present",
    );
    assert(
        importedCombined.getRoot().listCameras().length === 1,
        "Camera should be present",
    );
    assert(
        importedCombined.getRoot().listNodes().length === 3,
        "All nodes should be present",
    );

    // Check if the parenting structure is maintained
    const importedScene = importedCombined.getRoot().listScenes()[0];
    const importedRootNode = importedScene.listChildren()[0];
    assert(
        importedRootNode.getName() === "Root",
        "Root node should be present",
    );
    assert(
        importedRootNode.listChildren().length === 2,
        "Root node should have 2 children",
    );

    const importedCameraNode = importedRootNode.listChildren().find((node) =>
        node.getName() === "CameraNode"
    );
    const importedChildNode = importedRootNode.listChildren().find((node) =>
        node.getName() === "ChildNode"
    );

    assert(
        importedCameraNode !== undefined,
        "Camera node should be a child of the root node",
    );
    assert(
        importedChildNode !== undefined,
        "Child node should be a child of the root node",
    );
    assert(
        importedCameraNode?.getCamera() !== null,
        "Camera node should have a camera attached",
    );

    // Check if the animation is correctly linked to the root node
    const importedAnimation = importedCombined.getRoot().listAnimations()[0];
    const importedChannel = importedAnimation.listChannels()[0];
    assert(
        importedChannel.getTargetNode() === importedRootNode,
        "Animation should target the root node",
    );

    console.log("glTF import, combine, and export test passed successfully!");
});
