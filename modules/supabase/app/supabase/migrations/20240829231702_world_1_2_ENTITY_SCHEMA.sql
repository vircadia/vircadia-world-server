--
-- 
-- COMPOSITE TYPES
-- 
-- 

CREATE TYPE color4 AS (
    r NUMERIC,
    g NUMERIC,
    b NUMERIC,
    a NUMERIC
);

CREATE TYPE vector3 AS (
    x NUMERIC,
    y NUMERIC,
    z NUMERIC
);

CREATE TYPE quaternion AS (
    x NUMERIC,
    y NUMERIC,
    z NUMERIC,
    w NUMERIC
);

CREATE TYPE joint AS (
    name TEXT,
    index INTEGER,
    position vector3,
    rotation quaternion,
    scale vector3,
    inverse_bind_matrix NUMERIC[16],
    parent_index INTEGER
);

CREATE TYPE transform AS (
    position vector3,
    rotation vector3,
    scale vector3
);

CREATE TYPE script_source AS (
    raw_file_url TEXT,
    git_file_path TEXT,
    git_repo_url TEXT
);


-- Entities table
CREATE TABLE entities (
  general__uuid UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  general__name VARCHAR(255) NOT NULL,
  general__type TEXT NOT NULL,
  general__semantic_version TEXT NOT NULL DEFAULT '1.0.0',
  general__created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  general__updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  general__transform transform NOT NULL DEFAULT ((0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (1.0, 1.0, 1.0)),
  general__parent_entity_id UUID,
  
  -- Add permissions fields
  permissions__read TEXT[],
  permissions__write TEXT[],
  permissions__execute TEXT[],
  
  babylonjs__mesh_is_instance BOOLEAN DEFAULT FALSE,
  babylonjs__mesh_instance_of_id UUID,
  babylonjs__mesh_material_id UUID,
  babylonjs__mesh_gltf_file_path VARCHAR(255),
  babylonjs__mesh_gltf_data JSONB,
  babylonjs__mesh_physics_properties JSON,
  babylonjs__mesh_joints joint[],
  babylonjs__script_local_scripts script_source[],
  babylonjs__script_persistent_scripts script_source[],
  babylonjs__lod_mode TEXT,
  babylonjs__lod_auto BOOLEAN,
  babylonjs__lod_distance NUMERIC,
  babylonjs__lod_size NUMERIC,
  babylonjs__lod_hide NUMERIC,
  babylonjs__billboard_mode INTEGER,
  babylonjs__script_agent_script_raw_file_url TEXT[],
  babylonjs__script_agent_script_git_file_path TEXT[],
  babylonjs__script_agent_script_git_repo_url TEXT[],
  babylonjs__script_persistent_script_raw_file_url TEXT[],
  babylonjs__script_persistent_script_git_file_path TEXT[],
  babylonjs__script_persistent_script_git_repo_url TEXT[],
  -- Light properties
  babylonjs__light_type TEXT,
  babylonjs__light_intensity FLOAT,
  babylonjs__light_range FLOAT,
  babylonjs__light_radius FLOAT,
  babylonjs__light_diffuse color4,
  babylonjs__light_specular color4,
  babylonjs__light_direction vector3,
  babylonjs__light_angle FLOAT,
  babylonjs__light_exponent FLOAT,
  babylonjs__light_ground_color color4,
  babylonjs__light_intensity_mode TEXT,
  babylonjs__light_falloff_type TEXT,
  babylonjs__shadow_enabled BOOLEAN,
  babylonjs__shadow_bias FLOAT,
  babylonjs__shadow_blur_kernel FLOAT,
  babylonjs__shadow_darkness FLOAT,
  babylonjs__shadow_frustum_size FLOAT,
  babylonjs__shadow_map_size INTEGER,
  babylonjs__shadow_quality TEXT,
  babylonjs__exclude_mesh_ids TEXT[],
  babylonjs__include_only_mesh_ids TEXT[],
  -- Zone properties
  zone__properties JSON,
  -- Agent properties
  agent__ai_properties JSON,
  agent__inventory JSON,
  -- Material properties
  material__type TEXT,
  material__ambient color4,
  material__diffuse color4,
  material__specular color4,
  material__emissive color4,
  material__alpha FLOAT,
  material__backFaceCulling BOOLEAN,
  material__wireframe BOOLEAN,
  material__diffuseTexture TEXT,
  material__ambientTexture TEXT,
  material__opacityTexture TEXT,
  material__reflectionTexture TEXT,
  material__emissiveTexture TEXT,
  material__specularTexture TEXT,
  material__bumpTexture TEXT,
  material__lightmapTexture TEXT,
  material__refractionTexture TEXT,
  material__specularPower FLOAT,
  material__useAlphaFromDiffuseTexture BOOLEAN,
  material__useEmissiveAsIllumination BOOLEAN,
  material__useLightmapAsShadowmap BOOLEAN,
  material__roughness FLOAT,
  material__metallic FLOAT,
  material__useRoughnessFromMetallicTextureAlpha BOOLEAN,
  material__useRoughnessFromMetallicTextureGreen BOOLEAN,
  material__useMetallnessFromMetallicTextureBlue BOOLEAN,
  material__enableSpecularAntiAliasing BOOLEAN,
  material__environmentIntensity FLOAT,
  material__indexOfRefraction FLOAT,
  material__maxSimultaneousLights INTEGER,
  material__directIntensity FLOAT,
  material__environmentTexture TEXT,
  material__reflectivityTexture TEXT,
  material__metallicTexture TEXT,
  material__microSurfaceTexture TEXT,
  material__ambientTextureStrength FLOAT,
  material__ambientTextureImpactOnAnalyticalLights FLOAT,
  material__metallicF0Factor FLOAT,
  material__metallicReflectanceColor color4,
  material__reflectionColor color4,
  material__reflectivityColor color4,
  material__microSurface FLOAT,
  material__useMicroSurfaceFromReflectivityMapAlpha BOOLEAN,
  material__useAutoMicroSurfaceFromReflectivityMap BOOLEAN,
  material__useRadianceOverAlpha BOOLEAN,
  material__useSpecularOverAlpha BOOLEAN,
  material__usePhysicalLightFalloff BOOLEAN,
  material__useGLTFLightFalloff BOOLEAN,
  material__forceNormalForward BOOLEAN,
  material__enableIrradianceMap BOOLEAN,
  material__shader_code TEXT,
  material__shader_parameters JSON,
  material__custom_properties JSON,
  -- Babylon.js v2 Havok Physics properties
  babylonjs__physics_motion_type TEXT,
  babylonjs__physics_mass FLOAT,
  babylonjs__physics_friction FLOAT,
  babylonjs__physics_restitution FLOAT,
  babylonjs__physics_linear_velocity vector3,
  babylonjs__physics_angular_velocity vector3,
  babylonjs__physics_linear_damping FLOAT,
  babylonjs__physics_angular_damping FLOAT,
  babylonjs__physics_collision_filter_group INTEGER,
  babylonjs__physics_collision_filter_mask INTEGER,
  babylonjs__physics_shape_type TEXT,
  babylonjs__physics_shape_data JSON,
  FOREIGN KEY (general__parent_entity_id) REFERENCES entities(general__uuid) ON DELETE SET NULL,
  FOREIGN KEY (babylonjs__mesh_instance_of_id) REFERENCES entities(general__uuid) ON DELETE SET NULL,
  FOREIGN KEY (babylonjs__mesh_material_id) REFERENCES entities(general__uuid) ON DELETE SET NULL,
  
  -- CHECK constraints
  CONSTRAINT check_general_type CHECK (general__type IN ('MODEL', 'LIGHT', 'ZONE', 'VOLUME', 'AGENT', 'MATERIAL_STANDARD', 'MATERIAL_PROCEDURAL')),
  CONSTRAINT check_light_type CHECK (babylonjs__light_type IN ('POINT', 'DIRECTIONAL', 'SPOT', 'HEMISPHERIC')),
  CONSTRAINT check_shadow_quality CHECK (babylonjs__shadow_quality IN ('LOW', 'MEDIUM', 'HIGH'))
);

-- 
-- 
-- GENERAL SETUP
-- 
-- 

CREATE OR REPLACE FUNCTION update_base_table_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.general__updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Apply the trigger to the entities table
CREATE TRIGGER update_entities_modtime
BEFORE UPDATE ON entities
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

-- Enable RLS for the entities table
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for the entities table
ALTER PUBLICATION supabase_realtime
ADD TABLE entities;

-- Add indexes for better query performance
CREATE INDEX idx_entities_type ON entities(general__type);
CREATE INDEX idx_entities_parent_entity_id ON entities(general__parent_entity_id);
CREATE INDEX idx_entities_mesh_instance_of_id ON entities(babylonjs__mesh_instance_of_id);
CREATE INDEX idx_entities_mesh_material_id ON entities(babylonjs__mesh_material_id);

-- Add GIN indexes for JSONB and JSON columns to improve query performance on these fields
CREATE INDEX idx_entities_mesh_gltf_data ON entities USING GIN (babylonjs__mesh_gltf_data);
CREATE INDEX idx_entities_mesh_physics_properties ON entities USING GIN ((babylonjs__mesh_physics_properties::jsonb));
CREATE INDEX idx_entities_zone_properties ON entities USING GIN ((zone__properties::jsonb));
CREATE INDEX idx_entities_agent_ai_properties ON entities USING GIN ((agent__ai_properties::jsonb));
CREATE INDEX idx_entities_agent_inventory ON entities USING GIN ((agent__inventory::jsonb));
CREATE INDEX idx_entities_material_custom_properties ON entities USING GIN ((material__custom_properties::jsonb));
CREATE INDEX idx_entities_material_shader_parameters ON entities USING GIN ((material__shader_parameters::jsonb));
CREATE INDEX idx_entities_physics_shape_data ON entities USING GIN ((babylonjs__physics_shape_data::jsonb));

-- Add B-tree indexes for frequently queried columns
CREATE INDEX idx_entities_created_at ON entities(general__created_at);
CREATE INDEX idx_entities_updated_at ON entities(general__updated_at);
CREATE INDEX idx_entities_semantic_version ON entities(general__semantic_version);

-- Add partial indexes for boolean fields
CREATE INDEX idx_entities_mesh_is_instance ON entities(babylonjs__mesh_is_instance) WHERE babylonjs__mesh_is_instance = TRUE;
CREATE INDEX idx_entities_shadow_enabled ON entities(babylonjs__shadow_enabled) WHERE babylonjs__shadow_enabled = TRUE;

-- Add index for array fields
CREATE INDEX idx_entities_exclude_mesh_ids ON entities USING GIN (babylonjs__exclude_mesh_ids);
CREATE INDEX idx_entities_include_only_mesh_ids ON entities USING GIN (babylonjs__include_only_mesh_ids);

-- Add composite indexes for commonly used combinations
CREATE INDEX idx_entities_type_parent ON entities(general__type, general__parent_entity_id);
CREATE INDEX idx_entities_type_created_at ON entities(general__type, general__created_at);

-- Move these function definitions before the policy creations
-- Functions to check permissions

CREATE OR REPLACE FUNCTION can_read(entity_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_role TEXT;
  permission_array TEXT[];
BEGIN
  SELECT role INTO user_role FROM agent_profiles WHERE id = auth.uid();
  SELECT permissions__read INTO permission_array FROM entities WHERE general__uuid = entity_id;
  RETURN user_role = ANY(permission_array) OR '*' = ANY(permission_array);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, auth;

CREATE OR REPLACE FUNCTION can_write(entity_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_role TEXT;
  permission_array TEXT[];
BEGIN
  SELECT role INTO user_role FROM agent_profiles WHERE id = auth.uid();
  SELECT permissions__write INTO permission_array FROM entities WHERE general__uuid = entity_id;
  RETURN user_role = ANY(permission_array) OR '*' = ANY(permission_array);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, auth;

CREATE OR REPLACE FUNCTION can_execute(entity_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_role TEXT;
  permission_array TEXT[];
BEGIN
  SELECT role INTO user_role FROM agent_profiles WHERE id = auth.uid();
  SELECT permissions__execute INTO permission_array FROM entities WHERE general__uuid = entity_id;
  RETURN user_role = ANY(permission_array) OR '*' = ANY(permission_array);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, auth;

-- RLS for entities
ALTER TABLE entities ENABLE ROW LEVEL SECURITY;

-- Now create the policies using the functions we just defined
-- Policy for select: Allow authenticated users to read entities based on their role
CREATE POLICY entities_select_policy ON entities
    FOR SELECT USING (can_read(general__uuid));

-- Policy for insert: Allow authenticated users to insert entities if they have write permission
CREATE POLICY entities_insert_policy ON entities
    FOR INSERT WITH CHECK (can_write(general__uuid));

-- Policy for update: Allow authenticated users to update entities if they have write permission
CREATE POLICY entities_update_policy ON entities
    FOR UPDATE USING (can_write(general__uuid));

-- Policy for delete: Allow authenticated users to delete entities if they have write permission
CREATE POLICY entities_delete_policy ON entities
    FOR DELETE USING (can_write(general__uuid));

-- ENTITIES METADATA
CREATE TABLE entities_metadata (
    metadata_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    entity_id UUID NOT NULL REFERENCES entities(general__uuid) ON DELETE CASCADE,
    key TEXT NOT NULL,
    values_text TEXT[],
    values_numeric NUMERIC[],
    values_boolean BOOLEAN[],
    values_timestamp TIMESTAMPTZ[],
    createdat TIMESTAMPTZ DEFAULT NOW(),
    updatedat TIMESTAMPTZ DEFAULT NOW(),
    permissions__read TEXT[],
    permissions__write TEXT[],
    permissions__execute TEXT[],
    UNIQUE (entity_id, key)
);

-- Create indexes for better query performance using GIN for array columns
CREATE INDEX idx_entities_metadata_lookup ON entities_metadata (entity_id, key, values_text, values_numeric, values_boolean, values_timestamp);

-- Apply the trigger to all metadata tables
CREATE TRIGGER update_entities_metadata_modtime
BEFORE UPDATE ON entities_metadata
FOR EACH ROW EXECUTE FUNCTION update_base_table_modified_column();

-- Enable RLS for all metadata tables
ALTER TABLE entities_metadata ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for all metadata tables
ALTER PUBLICATION supabase_realtime ADD TABLE entities_metadata;

-- Functions to check permissions for entities_metadata

CREATE OR REPLACE FUNCTION can_read_metadata(metadata_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_role TEXT;
  permission_array TEXT[];
BEGIN
  SELECT role INTO user_role FROM agent_profiles WHERE id = auth.uid();
  SELECT permissions__read INTO permission_array FROM entities_metadata WHERE metadata_id = metadata_id;
  RETURN user_role = ANY(permission_array) OR '*' = ANY(permission_array) OR
         (SELECT COUNT(*) = 0 FROM entities_metadata WHERE metadata_id = metadata_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, auth;

CREATE OR REPLACE FUNCTION can_write_metadata(metadata_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_role TEXT;
  permission_array TEXT[];
BEGIN
  SELECT role INTO user_role FROM agent_profiles WHERE id = auth.uid();
  SELECT permissions__write INTO permission_array FROM entities_metadata WHERE metadata_id = metadata_id;
  RETURN user_role = ANY(permission_array) OR '*' = ANY(permission_array) OR
         (SELECT COUNT(*) = 0 FROM entities_metadata WHERE metadata_id = metadata_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, auth;

CREATE OR REPLACE FUNCTION can_execute_metadata(metadata_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
  user_role TEXT;
  permission_array TEXT[];
BEGIN
  SELECT role INTO user_role FROM agent_profiles WHERE id = auth.uid();
  SELECT permissions__execute INTO permission_array FROM entities_metadata WHERE metadata_id = metadata_id;
  RETURN user_role = ANY(permission_array) OR '*' = ANY(permission_array) OR
         (SELECT COUNT(*) = 0 FROM entities_metadata WHERE metadata_id = metadata_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public, auth;

-- Policy for select: Allow authenticated users to read metadata based on their role
CREATE POLICY entities_metadata_select_policy ON entities_metadata
    FOR SELECT USING (can_read_metadata(metadata_id));

-- Policy for insert: Allow authenticated users to insert metadata if they have write permission
CREATE POLICY entities_metadata_insert_policy ON entities_metadata
    FOR INSERT WITH CHECK (can_write_metadata(metadata_id));

-- Policy for update: Allow authenticated users to update metadata if they have write permission
CREATE POLICY entities_metadata_update_policy ON entities_metadata
    FOR UPDATE USING (can_write_metadata(metadata_id));

-- Policy for delete: Allow authenticated users to delete metadata if they have write permission
CREATE POLICY entities_metadata_delete_policy ON entities_metadata
    FOR DELETE USING (can_write_metadata(metadata_id));




