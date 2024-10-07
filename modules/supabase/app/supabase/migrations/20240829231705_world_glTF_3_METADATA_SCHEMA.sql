--
--
-- WORLD GLTF
--
--
CREATE TABLE world_gltf_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    world_gltf_id UUID NOT NULL REFERENCES world_gltf(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (world_gltf_id, key)
);

--
--
-- SCENES
--
--
CREATE TABLE world_gltf_scenes_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    scene_id UUID NOT NULL REFERENCES world_gltf_scenes(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (scene_id, key)
);

--
--
-- NODES
--
--
CREATE TABLE world_gltf_nodes_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    node_id UUID NOT NULL REFERENCES world_gltf_nodes(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (node_id, key)
);

--
--
-- MESHES
--
--
CREATE TABLE world_gltf_meshes_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mesh_id UUID NOT NULL REFERENCES world_gltf_meshes(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (mesh_id, key)
);

--
--
-- MATERIALS
--
--
CREATE TABLE world_gltf_materials_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    material_id UUID NOT NULL REFERENCES world_gltf_materials(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (material_id, key)
);

--
--
-- ANIMATIONS
--
--
CREATE TABLE world_gltf_animations_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    animation_id UUID NOT NULL REFERENCES world_gltf_animations(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (animation_id, key)
);

--
--
-- SKINS
--
--
CREATE TABLE world_gltf_skins_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    skin_id UUID NOT NULL REFERENCES world_gltf_skins(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (skin_id, key)
);

--
--
-- CAMERAS
--
--
CREATE TABLE world_gltf_cameras_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    camera_id UUID NOT NULL REFERENCES world_gltf_cameras(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (camera_id, key)
);

--
--
-- TEXTURES
--
--
CREATE TABLE world_gltf_textures_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    texture_id UUID NOT NULL REFERENCES world_gltf_textures(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (texture_id, key)
);

--
--
-- IMAGES
--
--
CREATE TABLE world_gltf_images_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    image_id UUID NOT NULL REFERENCES world_gltf_images(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (image_id, key)
);

--
--
-- SAMPLERS
--
--
CREATE TABLE world_gltf_samplers_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sampler_id UUID NOT NULL REFERENCES world_gltf_samplers(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (sampler_id, key)
);

--
--
-- BUFFERS
--
--
CREATE TABLE world_gltf_buffers_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buffer_id UUID NOT NULL REFERENCES world_gltf_buffers(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (buffer_id, key)
);

--
--
-- BUFFER VIEWS
--
--
CREATE TABLE world_gltf_buffer_views_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buffer_view_id UUID NOT NULL REFERENCES world_gltf_buffer_views(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (buffer_view_id, key)
);

--
--
-- ACCESSORS
--
--
CREATE TABLE world_gltf_accessors_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    accessor_id UUID NOT NULL REFERENCES world_gltf_accessors(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (accessor_id, key)
);

-- 
-- 
-- GENERAL SETUP
-- 
-- 

CREATE OR REPLACE FUNCTION update_metadata_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updatedat = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create indexes for better query performance using GIN for array columns
CREATE INDEX idx_world_gltf_metadata_lookup ON world_gltf_metadata (world_gltf_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_scenes_metadata_lookup ON world_gltf_scenes_metadata (scene_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_nodes_metadata_lookup ON world_gltf_nodes_metadata (node_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_meshes_metadata_lookup ON world_gltf_meshes_metadata (mesh_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_materials_metadata_lookup ON world_gltf_materials_metadata (material_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_animations_metadata_lookup ON world_gltf_animations_metadata (animation_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_skins_metadata_lookup ON world_gltf_skins_metadata (skin_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_cameras_metadata_lookup ON world_gltf_cameras_metadata (camera_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_textures_metadata_lookup ON world_gltf_textures_metadata (texture_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_images_metadata_lookup ON world_gltf_images_metadata (image_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_samplers_metadata_lookup ON world_gltf_samplers_metadata (sampler_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_buffers_metadata_lookup ON world_gltf_buffers_metadata (buffer_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_buffer_views_metadata_lookup ON world_gltf_buffer_views_metadata (buffer_view_id, key, values_text, values_numeric, values_boolean, values_timestamp);
CREATE INDEX idx_world_gltf_accessors_metadata_lookup ON world_gltf_accessors_metadata (accessor_id, key, values_text, values_numeric, values_boolean, values_timestamp);

-- Apply the trigger to all metadata tables
CREATE TRIGGER update_world_gltf_metadata_modtime
BEFORE UPDATE ON world_gltf_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_scenes_metadata_modtime
BEFORE UPDATE ON world_gltf_scenes_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_nodes_metadata_modtime
BEFORE UPDATE ON world_gltf_nodes_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_meshes_metadata_modtime
BEFORE UPDATE ON world_gltf_meshes_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_materials_metadata_modtime
BEFORE UPDATE ON world_gltf_materials_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_animations_metadata_modtime
BEFORE UPDATE ON world_gltf_animations_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_skins_metadata_modtime
BEFORE UPDATE ON world_gltf_skins_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_cameras_metadata_modtime
BEFORE UPDATE ON world_gltf_cameras_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_textures_metadata_modtime
BEFORE UPDATE ON world_gltf_textures_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_images_metadata_modtime
BEFORE UPDATE ON world_gltf_images_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_samplers_metadata_modtime
BEFORE UPDATE ON world_gltf_samplers_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_buffers_metadata_modtime
BEFORE UPDATE ON world_gltf_buffers_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_buffer_views_metadata_modtime
BEFORE UPDATE ON world_gltf_buffer_views_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_world_gltf_accessors_metadata_modtime
BEFORE UPDATE ON world_gltf_accessors_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

-- Enable RLS for all metadata tables
ALTER TABLE world_gltf_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_scenes_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_nodes_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_meshes_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_materials_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_animations_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_skins_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_cameras_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_textures_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_images_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_samplers_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_buffers_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_buffer_views_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE world_gltf_accessors_metadata ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for all metadata tables
ALTER PUBLICATION supabase_realtime
ADD TABLE world_gltf_metadata, world_gltf_scenes_metadata, world_gltf_nodes_metadata, world_gltf_meshes_metadata,
          world_gltf_materials_metadata, world_gltf_animations_metadata, world_gltf_skins_metadata, world_gltf_cameras_metadata,
          world_gltf_textures_metadata, world_gltf_images_metadata, world_gltf_samplers_metadata, world_gltf_buffers_metadata,
          world_gltf_buffer_views_metadata, world_gltf_accessors_metadata;