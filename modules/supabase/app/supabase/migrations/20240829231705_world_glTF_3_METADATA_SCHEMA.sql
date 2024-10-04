--
--
-- WORLD GLTF
--
--
CREATE TABLE world_gltf_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    world_gltf_id UUID NOT NULL REFERENCES world_gltf(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (world_gltf_id, key)
);

--
--
-- SCENES
--
--
CREATE TABLE scenes_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    scene_id UUID NOT NULL REFERENCES scenes(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (scene_id, key)
);

--
--
-- NODES
--
--
CREATE TABLE nodes_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    node_id UUID NOT NULL REFERENCES nodes(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (node_id, key)
);

--
--
-- MESHES
--
--
CREATE TABLE meshes_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mesh_id UUID NOT NULL REFERENCES meshes(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (mesh_id, key)
);

--
--
-- MATERIALS
--
--
CREATE TABLE materials_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    material_id UUID NOT NULL REFERENCES materials(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (material_id, key)
);

--
--
-- ANIMATIONS
--
--
CREATE TABLE animations_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    animation_id UUID NOT NULL REFERENCES animations(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (animation_id, key)
);

--
--
-- SKINS
--
--
CREATE TABLE skins_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    skin_id UUID NOT NULL REFERENCES skins(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (skin_id, key)
);

--
--
-- CAMERAS
--
--
CREATE TABLE cameras_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    camera_id UUID NOT NULL REFERENCES cameras(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (camera_id, key)
);

--
--
-- TEXTURES
--
--
CREATE TABLE textures_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    texture_id UUID NOT NULL REFERENCES textures(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (texture_id, key)
);

--
--
-- IMAGES
--
--
CREATE TABLE images_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    image_id UUID NOT NULL REFERENCES images(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (image_id, key)
);

--
--
-- SAMPLERS
--
--
CREATE TABLE samplers_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sampler_id UUID NOT NULL REFERENCES samplers(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (sampler_id, key)
);

--
--
-- BUFFERS
--
--
CREATE TABLE buffers_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buffer_id UUID NOT NULL REFERENCES buffers(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (buffer_id, key)
);

--
--
-- BUFFER VIEWS
--
--
CREATE TABLE buffer_views_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buffer_view_id UUID NOT NULL REFERENCES buffer_views(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (buffer_view_id, key)
);

--
--
-- ACCESSORS
--
--
CREATE TABLE accessors_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    accessor_id UUID NOT NULL REFERENCES accessors(vircadia_uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    value_text TEXT,
    value_numeric NUMERIC,
    value_boolean BOOLEAN,
    value_timestamp TIMESTAMPTZ,
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

-- Create indexes for better query performance
CREATE INDEX idx_world_gltf_metadata_lookup ON world_gltf_metadata(world_gltf_id, key);
CREATE INDEX idx_scenes_metadata_lookup ON scenes_metadata(scene_id, key);
CREATE INDEX idx_nodes_metadata_lookup ON nodes_metadata(node_id, key);
CREATE INDEX idx_meshes_metadata_lookup ON meshes_metadata(mesh_id, key);
CREATE INDEX idx_materials_metadata_lookup ON materials_metadata(material_id, key);
CREATE INDEX idx_animations_metadata_lookup ON animations_metadata(animation_id, key);
CREATE INDEX idx_skins_metadata_lookup ON skins_metadata(skin_id, key);
CREATE INDEX idx_cameras_metadata_lookup ON cameras_metadata(camera_id, key);
CREATE INDEX idx_textures_metadata_lookup ON textures_metadata(texture_id, key);
CREATE INDEX idx_images_metadata_lookup ON images_metadata(image_id, key);
CREATE INDEX idx_samplers_metadata_lookup ON samplers_metadata(sampler_id, key);
CREATE INDEX idx_buffers_metadata_lookup ON buffers_metadata(buffer_id, key);
CREATE INDEX idx_buffer_views_metadata_lookup ON buffer_views_metadata(buffer_view_id, key);
CREATE INDEX idx_accessors_metadata_lookup ON accessors_metadata(accessor_id, key);

-- Apply the trigger to all metadata tables
CREATE TRIGGER update_world_gltf_metadata_modtime
BEFORE UPDATE ON world_gltf_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_scenes_metadata_modtime
BEFORE UPDATE ON scenes_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_nodes_metadata_modtime
BEFORE UPDATE ON nodes_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_meshes_metadata_modtime
BEFORE UPDATE ON meshes_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_materials_metadata_modtime
BEFORE UPDATE ON materials_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_animations_metadata_modtime
BEFORE UPDATE ON animations_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_skins_metadata_modtime
BEFORE UPDATE ON skins_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_cameras_metadata_modtime
BEFORE UPDATE ON cameras_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_textures_metadata_modtime
BEFORE UPDATE ON textures_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_images_metadata_modtime
BEFORE UPDATE ON images_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_samplers_metadata_modtime
BEFORE UPDATE ON samplers_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_buffers_metadata_modtime
BEFORE UPDATE ON buffers_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_buffer_views_metadata_modtime
BEFORE UPDATE ON buffer_views_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

CREATE TRIGGER update_accessors_metadata_modtime
BEFORE UPDATE ON accessors_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

-- Enable RLS for all metadata tables
ALTER TABLE world_gltf_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE scenes_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE nodes_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE meshes_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE materials_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE animations_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE skins_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE cameras_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE textures_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE images_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE samplers_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE buffers_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE buffer_views_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE accessors_metadata ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for all metadata tables
ALTER PUBLICATION supabase_realtime
ADD TABLE world_gltf_metadata, scenes_metadata, nodes_metadata, meshes_metadata,
          materials_metadata, animations_metadata, skins_metadata, cameras_metadata,
          textures_metadata, images_metadata, samplers_metadata, buffers_metadata,
          buffer_views_metadata, accessors_metadata;