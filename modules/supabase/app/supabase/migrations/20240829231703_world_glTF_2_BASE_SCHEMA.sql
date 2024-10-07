-- This migration conforms to the glTF 2.0 specification and uses custom features within extras.
-- If for some reason it falls out alignment with the ability to serialize without much conversion to glTF 2.0, then please update the migration to conform again.
-- Any fields prefixed with "vircadia_" are custom and not compliant with glTF 2.0, and need to be moved to and from "extras" as needed.

--
--
-- WORLD_GLTF
--
--

-- Create the world_gltf table
CREATE TABLE world_gltf (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),

    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_name TEXT NOT NULL,
    vircadia_metadata JSONB NOT NULL,

    gltf_extensionsUsed TEXT[],
    gltf_extensionsRequired TEXT[],
    gltf_extensions JSONB,
    gltf_extras JSONB,
    gltf_asset JSONB NOT NULL,
    gltf_scene INTEGER  -- This is the index of the default scene
);

--
--
-- SCENES
--
--

-- Create the world_gltf_scenes table
CREATE TABLE world_gltf_scenes (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_nodes JSONB,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_scene_clearColor JSONB,
    vircadia_babylonjs_scene_ambientColor JSONB,
    vircadia_babylonjs_scene_gravity JSONB,
    vircadia_babylonjs_scene_activeCamera TEXT,
    vircadia_babylonjs_scene_collisionsEnabled BOOLEAN,
    vircadia_babylonjs_scene_physicsEnabled BOOLEAN,
    vircadia_babylonjs_scene_physicsGravity JSONB,
    vircadia_babylonjs_scene_physicsEngine TEXT,
    vircadia_babylonjs_scene_autoAnimate BOOLEAN,
    vircadia_babylonjs_scene_autoAnimateFrom NUMERIC,
    vircadia_babylonjs_scene_autoAnimateTo NUMERIC,
    vircadia_babylonjs_scene_autoAnimateLoop BOOLEAN,
    vircadia_babylonjs_scene_autoAnimateSpeed NUMERIC
);

--
--
-- NODES
--
--

-- Create the world_gltf_nodes table
CREATE TABLE world_gltf_nodes (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_camera TEXT,
    gltf_children JSONB,
    gltf_skin TEXT,
    gltf_matrix NUMERIC[16] DEFAULT ARRAY[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1],
    gltf_mesh TEXT,
    gltf_rotation NUMERIC[4] DEFAULT ARRAY[0,0,0,1],
    gltf_scale NUMERIC[3] DEFAULT ARRAY[1,1,1],
    gltf_translation NUMERIC[3] DEFAULT ARRAY[0,0,0],
    gltf_weights JSONB,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- MESHES
--
--

-- Create the world_gltf_meshes table
CREATE TABLE world_gltf_meshes (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_primitives JSONB NOT NULL,
    gltf_weights JSONB,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- MATERIALS
--
--

-- Create the world_gltf_materials table
CREATE TABLE world_gltf_materials (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_pbrMetallicRoughness JSONB,
    gltf_normalTexture JSONB,
    gltf_occlusionTexture JSONB,
    gltf_emissiveTexture JSONB,
    gltf_emissiveFactor NUMERIC[3] DEFAULT ARRAY[0,0,0],
    gltf_alphaMode TEXT DEFAULT 'OPAQUE',
    gltf_alphaCutoff NUMERIC DEFAULT 0.5,
    gltf_doubleSided BOOLEAN DEFAULT false,
    gltf_extensions JSONB,
    gltf_extras JSONB,
    CONSTRAINT check_alphamode CHECK (gltf_alphaMode IN ('OPAQUE', 'MASK', 'BLEND')),
    CONSTRAINT check_pbr_metallic_roughness_structure CHECK (
        gltf_pbrMetallicRoughness IS NULL OR (
            (gltf_pbrMetallicRoughness->>'baseColorFactor' IS NULL OR
             jsonb_array_length(gltf_pbrMetallicRoughness->'baseColorFactor') = 4) AND
            (gltf_pbrMetallicRoughness->>'metallicFactor' IS NULL OR
             jsonb_typeof(gltf_pbrMetallicRoughness->'metallicFactor') = 'number') AND
            (gltf_pbrMetallicRoughness->>'roughnessFactor' IS NULL OR
             jsonb_typeof(gltf_pbrMetallicRoughness->'roughnessFactor') = 'number') AND
            (gltf_pbrMetallicRoughness->>'baseColorTexture' IS NULL OR
             jsonb_typeof(gltf_pbrMetallicRoughness->'baseColorTexture') = 'object') AND
            (gltf_pbrMetallicRoughness->>'metallicRoughnessTexture' IS NULL OR
             jsonb_typeof(gltf_pbrMetallicRoughness->'metallicRoughnessTexture') = 'object')
        )
    ),

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- TEXTURES
--
--

-- Create the world_gltf_textures table
CREATE TABLE world_gltf_textures (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_sampler TEXT,
    gltf_source TEXT,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- IMAGES
--
--

-- Create the world_gltf_images table
CREATE TABLE world_gltf_images (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_uri TEXT,
    gltf_mimeType TEXT,
    gltf_bufferView TEXT,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- SAMPLERS
--
--

-- Create the world_gltf_samplers table
CREATE TABLE world_gltf_samplers (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_magFilter TEXT,
    gltf_minFilter TEXT,
    gltf_wrapS TEXT,
    gltf_wrapT TEXT,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- BUFFERS
--
--

-- Create the world_gltf_buffers table
CREATE TABLE world_gltf_buffers (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_uri TEXT,
    gltf_byteLength INTEGER NOT NULL,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- BUFFER VIEWS
--
--

-- Create the world_gltf_buffer_views table
CREATE TABLE world_gltf_buffer_views (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_buffer TEXT NOT NULL,
    gltf_byteOffset INTEGER DEFAULT 0,
    gltf_byteLength INTEGER NOT NULL,
    gltf_byteStride INTEGER,
    gltf_target TEXT,
    gltf_name TEXT,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- ACCESSORS
--
--

-- Create the world_gltf_accessors table
CREATE TABLE world_gltf_accessors (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_bufferView TEXT,
    gltf_byteOffset INTEGER DEFAULT 0,
    gltf_componentType INTEGER NOT NULL,
    gltf_normalized BOOLEAN DEFAULT false,
    gltf_count INTEGER NOT NULL,
    gltf_type TEXT NOT NULL,
    gltf_max JSONB,
    gltf_min JSONB,
    gltf_name TEXT,
    gltf_sparse JSONB,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- ANIMATIONS
--
--

-- Create the world_gltf_animations table
CREATE TABLE world_gltf_animations (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_channels JSONB NOT NULL,
    gltf_samplers JSONB NOT NULL,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- SKINS
--
--

-- Create the world_gltf_skins table
CREATE TABLE world_gltf_skins (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_inverseBindMatrices TEXT,
    gltf_skeleton TEXT,
    gltf_joints JSONB NOT NULL,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);

--
--
-- CAMERAS
--
--

-- Create the world_gltf_cameras table
CREATE TABLE world_gltf_cameras (
    vircadia_uuid UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vircadia_world_uuid UUID NOT NULL REFERENCES world_gltf(vircadia_uuid),

    gltf_name TEXT,
    gltf_type TEXT NOT NULL,
    gltf_orthographic JSONB,
    gltf_perspective JSONB,
    gltf_extensions JSONB,
    gltf_extras JSONB,

    -- New properties
    
    vircadia_version TEXT,
    vircadia_createdat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_updatedat TIMESTAMPTZ DEFAULT NOW(),
    vircadia_babylonjs_lod_mode TEXT,
    vircadia_babylonjs_lod_auto BOOLEAN,
    vircadia_babylonjs_lod_distance NUMERIC,
    vircadia_babylonjs_lod_size NUMERIC,
    vircadia_babylonjs_lod_hide NUMERIC,
    vircadia_babylonjs_billboard_mode INTEGER,
    vircadia_babylonjs_light_lightmap TEXT,
    vircadia_babylonjs_light_level NUMERIC,
    vircadia_babylonjs_light_color_space TEXT,
    vircadia_babylonjs_light_texcoord INTEGER,
    vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
    vircadia_babylonjs_light_mode TEXT,
    vircadia_babylonjs_script_agent_scripts TEXT[],
    vircadia_babylonjs_script_persistent_scripts TEXT[]
);


-- 
-- 
-- GENERAL SETUP
-- 
-- 

CREATE OR REPLACE FUNCTION update_base_table_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.vircadia_updatedat = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply the trigger to all tables with vircadia_updatedat column
CREATE TRIGGER update_world_gltf_modtime
BEFORE UPDATE ON world_gltf
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_scenes_modtime
BEFORE UPDATE ON world_gltf_scenes
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_nodes_modtime
BEFORE UPDATE ON world_gltf_nodes
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_meshes_modtime
BEFORE UPDATE ON world_gltf_meshes
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_materials_modtime
BEFORE UPDATE ON world_gltf_materials
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_textures_modtime
BEFORE UPDATE ON world_gltf_textures
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_images_modtime
BEFORE UPDATE ON world_gltf_images
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_samplers_modtime
BEFORE UPDATE ON world_gltf_samplers
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_buffers_modtime
BEFORE UPDATE ON world_gltf_buffers
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_buffer_views_modtime
BEFORE UPDATE ON world_gltf_buffer_views
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_accessors_modtime
BEFORE UPDATE ON world_gltf_accessors
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_animations_modtime
BEFORE UPDATE ON world_gltf_animations
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_cameras_modtime
BEFORE UPDATE ON world_gltf_cameras
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

CREATE TRIGGER update_world_gltf_skins_modtime
BEFORE UPDATE ON world_gltf_skins
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

-- Enable RLS for all tables
ALTER TABLE agent_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_scenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_nodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_meshes ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_textures ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_samplers ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_buffers ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_buffer_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_accessors ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_animations ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_skins ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_cameras ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for all tables
ALTER PUBLICATION supabase_realtime
ADD TABLE world_gltf, world_gltf_scenes, world_gltf_nodes, world_gltf_meshes, world_gltf_materials, world_gltf_textures,
          world_gltf_images, world_gltf_samplers, world_gltf_animations, world_gltf_skins, world_gltf_cameras, world_gltf_buffers,
          world_gltf_buffer_views, world_gltf_accessors;

-- Add indexes for better query performance
CREATE INDEX idx_world_gltf_scenes_gltf_name ON world_gltf_scenes(gltf_name);
CREATE INDEX idx_world_gltf_nodes_gltf_name ON world_gltf_nodes(gltf_name);
CREATE INDEX idx_world_gltf_meshes_gltf_name ON world_gltf_meshes(gltf_name);
CREATE INDEX idx_world_gltf_materials_gltf_name ON world_gltf_materials(gltf_name);
CREATE INDEX idx_world_gltf_textures_gltf_name ON world_gltf_textures(gltf_name);
CREATE INDEX idx_world_gltf_images_gltf_name ON world_gltf_images(gltf_name);
CREATE INDEX idx_world_gltf_samplers_gltf_name ON world_gltf_samplers(gltf_name);
CREATE INDEX idx_world_gltf_animations_gltf_name ON world_gltf_animations(gltf_name);
CREATE INDEX idx_world_gltf_skins_gltf_name ON world_gltf_skins(gltf_name);
CREATE INDEX idx_world_gltf_cameras_gltf_name ON world_gltf_cameras(gltf_name);
CREATE INDEX idx_world_gltf_buffers_gltf_name ON world_gltf_buffers(gltf_name);
CREATE INDEX idx_world_gltf_buffer_views_gltf_name ON world_gltf_buffer_views(gltf_name);
CREATE INDEX idx_world_gltf_accessors_gltf_name ON world_gltf_accessors(gltf_name);

-- Add GIN indexes for JSONB columns to improve query performance on these fields
CREATE INDEX idx_worlds_gltf_gltf_extensions ON world_gltf USING GIN (gltf_extensions);
CREATE INDEX idx_world_gltf_scenes_gltf_nodes ON world_gltf_scenes USING GIN (gltf_nodes);
CREATE INDEX idx_world_gltf_meshes_gltf_primitives ON world_gltf_meshes USING GIN (gltf_primitives);
CREATE INDEX idx_world_gltf_materials_gltf_pbr_metallic_roughness ON world_gltf_materials USING GIN (gltf_pbrMetallicRoughness);
CREATE INDEX idx_world_gltf_animations_gltf_channels ON world_gltf_animations USING GIN (gltf_channels);
CREATE INDEX idx_world_gltf_animations_gltf_samplers ON world_gltf_animations USING GIN (gltf_samplers);
CREATE INDEX idx_world_gltf_skins_gltf_joints ON world_gltf_skins USING GIN (gltf_joints);
CREATE INDEX idx_world_gltf_accessors_gltf_sparse ON world_gltf_accessors USING GIN (gltf_sparse);