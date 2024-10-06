-- World GLTF

CREATE OR REPLACE FUNCTION create_world_gltf(
  p_name TEXT,
  p_version TEXT,
  p_metadata JSONB,
  p_defaultScene TEXT,
  p_extensionsUsed TEXT[],
  p_extensionsRequired TEXT[],
  p_extensions JSONB,
  p_extras JSONB,
  p_asset JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT (is_admin()) THEN
    RAISE EXCEPTION 'Only admins can create world_gltf entries';
  END IF;

  INSERT INTO world_gltf (name, version, metadata, defaultScene, extensionsUsed, extensionsRequired, extensions, extras, asset,  vircadia_version)
  VALUES (p_name, p_version, p_metadata, p_defaultScene, p_extensionsUsed, p_extensionsRequired, p_extensions, p_extras, p_asset, p_vircadia_name, p_vircadia_version)
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_world_gltf(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_version TEXT DEFAULT NULL,
  p_metadata JSONB DEFAULT NULL,
  p_defaultScene TEXT DEFAULT NULL,
  p_extensionsUsed TEXT[] DEFAULT NULL,
  p_extensionsRequired TEXT[] DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_asset JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf entries';
  END IF;

  UPDATE world_gltf
  SET 
    name = COALESCE(p_name, name),
    version = COALESCE(p_version, version),
    metadata = COALESCE(p_metadata, metadata),
    defaultScene = COALESCE(p_defaultScene, defaultScene),
    extensionsUsed = COALESCE(p_extensionsUsed, extensionsUsed),
    extensionsRequired = COALESCE(p_extensionsRequired, extensionsRequired),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    asset = COALESCE(p_asset, asset),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_world_gltf(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT (is_admin()) THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf entries';
  END IF;

  DELETE FROM world_gltf WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for world_gltf
CREATE POLICY world_gltf_select_policy ON world_gltf FOR SELECT USING (true);
CREATE POLICY world_gltf_insert_policy ON world_gltf FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_update_policy ON world_gltf FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_delete_policy ON world_gltf FOR DELETE USING (is_admin());

-- Scenes

CREATE OR REPLACE FUNCTION create_scene(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_nodes JSONB,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_scene_clearColor JSONB,
  p_vircadia_babylonjs_scene_ambientColor JSONB,
  p_vircadia_babylonjs_scene_gravity JSONB,
  p_vircadia_babylonjs_scene_activeCamera TEXT,
  p_vircadia_babylonjs_scene_collisionsEnabled BOOLEAN,
  p_vircadia_babylonjs_scene_physicsEnabled BOOLEAN,
  p_vircadia_babylonjs_scene_physicsGravity JSONB,
  p_vircadia_babylonjs_scene_physicsEngine TEXT,
  p_vircadia_babylonjs_scene_autoAnimate BOOLEAN,
  p_vircadia_babylonjs_scene_autoAnimateFrom NUMERIC,
  p_vircadia_babylonjs_scene_autoAnimateTo NUMERIC,
  p_vircadia_babylonjs_scene_autoAnimateLoop BOOLEAN,
  p_vircadia_babylonjs_scene_autoAnimateSpeed NUMERIC
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create scene entries';
  END IF;

  INSERT INTO scenes (
    vircadia_world_uuid, name, nodes, extensions, extras,
     vircadia_version,
    vircadia_babylonjs_scene_clearColor, vircadia_babylonjs_scene_ambientColor,
    vircadia_babylonjs_scene_gravity, vircadia_babylonjs_scene_activeCamera,
    vircadia_babylonjs_scene_collisionsEnabled, vircadia_babylonjs_scene_physicsEnabled,
    vircadia_babylonjs_scene_physicsGravity, vircadia_babylonjs_scene_physicsEngine,
    vircadia_babylonjs_scene_autoAnimate, vircadia_babylonjs_scene_autoAnimateFrom,
    vircadia_babylonjs_scene_autoAnimateTo, vircadia_babylonjs_scene_autoAnimateLoop,
    vircadia_babylonjs_scene_autoAnimateSpeed
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_nodes, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version,
    p_vircadia_babylonjs_scene_clearColor, p_vircadia_babylonjs_scene_ambientColor,
    p_vircadia_babylonjs_scene_gravity, p_vircadia_babylonjs_scene_activeCamera,
    p_vircadia_babylonjs_scene_collisionsEnabled, p_vircadia_babylonjs_scene_physicsEnabled,
    p_vircadia_babylonjs_scene_physicsGravity, p_vircadia_babylonjs_scene_physicsEngine,
    p_vircadia_babylonjs_scene_autoAnimate, p_vircadia_babylonjs_scene_autoAnimateFrom,
    p_vircadia_babylonjs_scene_autoAnimateTo, p_vircadia_babylonjs_scene_autoAnimateLoop,
    p_vircadia_babylonjs_scene_autoAnimateSpeed
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_scene(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_nodes JSONB DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_scene_clearColor JSONB DEFAULT NULL,
  p_vircadia_babylonjs_scene_ambientColor JSONB DEFAULT NULL,
  p_vircadia_babylonjs_scene_gravity JSONB DEFAULT NULL,
  p_vircadia_babylonjs_scene_activeCamera TEXT DEFAULT NULL,
  p_vircadia_babylonjs_scene_collisionsEnabled BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_scene_physicsEnabled BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_scene_physicsGravity JSONB DEFAULT NULL,
  p_vircadia_babylonjs_scene_physicsEngine TEXT DEFAULT NULL,
  p_vircadia_babylonjs_scene_autoAnimate BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_scene_autoAnimateFrom NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_scene_autoAnimateTo NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_scene_autoAnimateLoop BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_scene_autoAnimateSpeed NUMERIC DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update scene entries';
  END IF;

  UPDATE scenes
  SET 
    name = COALESCE(p_name, name),
    nodes = COALESCE(p_nodes, nodes),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_scene_clearColor = COALESCE(p_vircadia_babylonjs_scene_clearColor, vircadia_babylonjs_scene_clearColor),
    vircadia_babylonjs_scene_ambientColor = COALESCE(p_vircadia_babylonjs_scene_ambientColor, vircadia_babylonjs_scene_ambientColor),
    vircadia_babylonjs_scene_gravity = COALESCE(p_vircadia_babylonjs_scene_gravity, vircadia_babylonjs_scene_gravity),
    vircadia_babylonjs_scene_activeCamera = COALESCE(p_vircadia_babylonjs_scene_activeCamera, vircadia_babylonjs_scene_activeCamera),
    vircadia_babylonjs_scene_collisionsEnabled = COALESCE(p_vircadia_babylonjs_scene_collisionsEnabled, vircadia_babylonjs_scene_collisionsEnabled),
    vircadia_babylonjs_scene_physicsEnabled = COALESCE(p_vircadia_babylonjs_scene_physicsEnabled, vircadia_babylonjs_scene_physicsEnabled),
    vircadia_babylonjs_scene_physicsGravity = COALESCE(p_vircadia_babylonjs_scene_physicsGravity, vircadia_babylonjs_scene_physicsGravity),
    vircadia_babylonjs_scene_physicsEngine = COALESCE(p_vircadia_babylonjs_scene_physicsEngine, vircadia_babylonjs_scene_physicsEngine),
    vircadia_babylonjs_scene_autoAnimate = COALESCE(p_vircadia_babylonjs_scene_autoAnimate, vircadia_babylonjs_scene_autoAnimate),
    vircadia_babylonjs_scene_autoAnimateFrom = COALESCE(p_vircadia_babylonjs_scene_autoAnimateFrom, vircadia_babylonjs_scene_autoAnimateFrom),
    vircadia_babylonjs_scene_autoAnimateTo = COALESCE(p_vircadia_babylonjs_scene_autoAnimateTo, vircadia_babylonjs_scene_autoAnimateTo),
    vircadia_babylonjs_scene_autoAnimateLoop = COALESCE(p_vircadia_babylonjs_scene_autoAnimateLoop, vircadia_babylonjs_scene_autoAnimateLoop),
    vircadia_babylonjs_scene_autoAnimateSpeed = COALESCE(p_vircadia_babylonjs_scene_autoAnimateSpeed, vircadia_babylonjs_scene_autoAnimateSpeed)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_scene(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete scene entries';
  END IF;

  DELETE FROM scenes WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for scenes
CREATE POLICY scenes_select_policy ON scenes FOR SELECT USING (true);
CREATE POLICY scenes_insert_policy ON scenes FOR INSERT WITH CHECK (is_admin());
CREATE POLICY scenes_update_policy ON scenes FOR UPDATE USING (is_admin());
CREATE POLICY scenes_delete_policy ON scenes FOR DELETE USING (is_admin());

-- Nodes

CREATE OR REPLACE FUNCTION create_node(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_camera TEXT,
  p_children JSONB,
  p_skin TEXT,
  p_matrix NUMERIC[16],
  p_mesh TEXT,
  p_rotation NUMERIC[4],
  p_scale NUMERIC[3],
  p_translation NUMERIC[3],
  p_weights JSONB,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create node entries';
  END IF;

  INSERT INTO nodes (
    vircadia_world_uuid, name, camera, children, skin, matrix, mesh, rotation, scale, translation, weights, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_distance,
    vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide, vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap,
    vircadia_babylonjs_light_level, vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord,
    vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts,
    vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_camera, p_children, p_skin, p_matrix, p_mesh, p_rotation, p_scale, p_translation, p_weights,
    p_extensions, p_extras, p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide, p_vircadia_babylonjs_billboard_mode,
    p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level, p_vircadia_babylonjs_light_color_space,
    p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap, p_vircadia_babylonjs_light_mode,
    p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_node(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_camera TEXT DEFAULT NULL,
  p_children JSONB DEFAULT NULL,
  p_skin TEXT DEFAULT NULL,
  p_matrix NUMERIC[16] DEFAULT NULL,
  p_mesh TEXT DEFAULT NULL,
  p_rotation NUMERIC[4] DEFAULT NULL,
  p_scale NUMERIC[3] DEFAULT NULL,
  p_translation NUMERIC[3] DEFAULT NULL,
  p_weights JSONB DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update node entries';
  END IF;

  UPDATE nodes
  SET 
    name = COALESCE(p_name, name),
    camera = COALESCE(p_camera, camera),
    children = COALESCE(p_children, children),
    skin = COALESCE(p_skin, skin),
    matrix = COALESCE(p_matrix, matrix),
    mesh = COALESCE(p_mesh, mesh),
    rotation = COALESCE(p_rotation, rotation),
    scale = COALESCE(p_scale, scale),
    translation = COALESCE(p_translation, translation),
    weights = COALESCE(p_weights, weights),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_node(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete node entries';
  END IF;

  DELETE FROM nodes WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for nodes
CREATE POLICY nodes_select_policy ON nodes FOR SELECT USING (true);
CREATE POLICY nodes_insert_policy ON nodes FOR INSERT WITH CHECK (is_admin());
CREATE POLICY nodes_update_policy ON nodes FOR UPDATE USING (is_admin());
CREATE POLICY nodes_delete_policy ON nodes FOR DELETE USING (is_admin());

-- Meshes

CREATE OR REPLACE FUNCTION create_mesh(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_primitives JSONB,
  p_weights JSONB,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create mesh entries';
  END IF;

  INSERT INTO meshes (
    vircadia_world_uuid, name, primitives, weights, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_primitives, p_weights, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_mesh(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_primitives JSONB DEFAULT NULL,
  p_weights JSONB DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update mesh entries';
  END IF;

  UPDATE meshes
  SET 
    name = COALESCE(p_name, name),
    primitives = COALESCE(p_primitives, primitives),
    weights = COALESCE(p_weights, weights),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_mesh(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete mesh entries';
  END IF;

  DELETE FROM meshes WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for meshes
CREATE POLICY meshes_select_policy ON meshes FOR SELECT USING (true);
CREATE POLICY meshes_insert_policy ON meshes FOR INSERT WITH CHECK (is_admin());
CREATE POLICY meshes_update_policy ON meshes FOR UPDATE USING (is_admin());
CREATE POLICY meshes_delete_policy ON meshes FOR DELETE USING (is_admin());

-- Materials

CREATE OR REPLACE FUNCTION create_material(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_pbrMetallicRoughness JSONB,
  p_normalTexture JSONB,
  p_occlusionTexture JSONB,
  p_emissiveTexture JSONB,
  p_emissiveFactor NUMERIC[3],
  p_alphaMode TEXT,
  p_alphaCutoff NUMERIC,
  p_doubleSided BOOLEAN,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create material entries';
  END IF;

  INSERT INTO materials (
    vircadia_world_uuid, name, pbrMetallicRoughness, normalTexture, occlusionTexture, emissiveTexture,
    emissiveFactor, alphaMode, alphaCutoff, doubleSided, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_pbrMetallicRoughness, p_normalTexture, p_occlusionTexture, p_emissiveTexture,
    p_emissiveFactor, p_alphaMode, p_alphaCutoff, p_doubleSided, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_material(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_pbrMetallicRoughness JSONB DEFAULT NULL,
  p_normalTexture JSONB DEFAULT NULL,
  p_occlusionTexture JSONB DEFAULT NULL,
  p_emissiveTexture JSONB DEFAULT NULL,
  p_emissiveFactor NUMERIC[3] DEFAULT NULL,
  p_alphaMode TEXT DEFAULT NULL,
  p_alphaCutoff NUMERIC DEFAULT NULL,
  p_doubleSided BOOLEAN DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update material entries';
  END IF;

  UPDATE materials
  SET 
    name = COALESCE(p_name, name),
    pbrMetallicRoughness = COALESCE(p_pbrMetallicRoughness, pbrMetallicRoughness),
    normalTexture = COALESCE(p_normalTexture, normalTexture),
    occlusionTexture = COALESCE(p_occlusionTexture, occlusionTexture),
    emissiveTexture = COALESCE(p_emissiveTexture, emissiveTexture),
    emissiveFactor = COALESCE(p_emissiveFactor, emissiveFactor),
    alphaMode = COALESCE(p_alphaMode, alphaMode),
    alphaCutoff = COALESCE(p_alphaCutoff, alphaCutoff),
    doubleSided = COALESCE(p_doubleSided, doubleSided),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_material(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete material entries';
  END IF;

  DELETE FROM materials WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for materials
CREATE POLICY materials_select_policy ON materials FOR SELECT USING (true);
CREATE POLICY materials_insert_policy ON materials FOR INSERT WITH CHECK (is_admin());
CREATE POLICY materials_update_policy ON materials FOR UPDATE USING (is_admin());
CREATE POLICY materials_delete_policy ON materials FOR DELETE USING (is_admin());

-- Textures

CREATE OR REPLACE FUNCTION create_texture(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_sampler TEXT,
  p_source TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create texture entries';
  END IF;

  INSERT INTO textures (
    vircadia_world_uuid, name, sampler, source, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_sampler, p_source, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_texture(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_sampler TEXT DEFAULT NULL,
  p_source TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update texture entries';
  END IF;

  UPDATE textures
  SET 
    name = COALESCE(p_name, name),
    sampler = COALESCE(p_sampler, sampler),
    source = COALESCE(p_source, source),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_texture(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete texture entries';
  END IF;

  DELETE FROM textures WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for textures
CREATE POLICY textures_select_policy ON textures FOR SELECT USING (true);
CREATE POLICY textures_insert_policy ON textures FOR INSERT WITH CHECK (is_admin());
CREATE POLICY textures_update_policy ON textures FOR UPDATE USING (is_admin());
CREATE POLICY textures_delete_policy ON textures FOR DELETE USING (is_admin());

-- Images

CREATE OR REPLACE FUNCTION create_image(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_uri TEXT,
  p_mimeType TEXT,
  p_bufferView TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create image entries';
  END IF;

  INSERT INTO images (
    vircadia_world_uuid, name, uri, mimeType, bufferView, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_uri, p_mimeType, p_bufferView, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_image(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_uri TEXT DEFAULT NULL,
  p_mimeType TEXT DEFAULT NULL,
  p_bufferView TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update image entries';
  END IF;

  UPDATE images
  SET 
    name = COALESCE(p_name, name),
    uri = COALESCE(p_uri, uri),
    mimeType = COALESCE(p_mimeType, mimeType),
    bufferView = COALESCE(p_bufferView, bufferView),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_image(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete image entries';
  END IF;

  DELETE FROM images WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for images
CREATE POLICY images_select_policy ON images FOR SELECT USING (true);
CREATE POLICY images_insert_policy ON images FOR INSERT WITH CHECK (is_admin());
CREATE POLICY images_update_policy ON images FOR UPDATE USING (is_admin());
CREATE POLICY images_delete_policy ON images FOR DELETE USING (is_admin());

-- Samplers

CREATE OR REPLACE FUNCTION create_sampler(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_magFilter TEXT,
  p_minFilter TEXT,
  p_wrapS TEXT,
  p_wrapT TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create sampler entries';
  END IF;

  INSERT INTO samplers (
    vircadia_world_uuid, name, magFilter, minFilter, wrapS, wrapT, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_magFilter, p_minFilter, p_wrapS, p_wrapT, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_sampler(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_magFilter TEXT DEFAULT NULL,
  p_minFilter TEXT DEFAULT NULL,
  p_wrapS TEXT DEFAULT NULL,
  p_wrapT TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update sampler entries';
  END IF;

  UPDATE samplers
  SET 
    name = COALESCE(p_name, name),
    magFilter = COALESCE(p_magFilter, magFilter),
    minFilter = COALESCE(p_minFilter, minFilter),
    wrapS = COALESCE(p_wrapS, wrapS),
    wrapT = COALESCE(p_wrapT, wrapT),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_sampler(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete sampler entries';
  END IF;

  DELETE FROM samplers WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for samplers
CREATE POLICY samplers_select_policy ON samplers FOR SELECT USING (true);
CREATE POLICY samplers_insert_policy ON samplers FOR INSERT WITH CHECK (is_admin());
CREATE POLICY samplers_update_policy ON samplers FOR UPDATE USING (is_admin());
CREATE POLICY samplers_delete_policy ON samplers FOR DELETE USING (is_admin());

-- Buffers

CREATE OR REPLACE FUNCTION create_buffer(
  p_vircadia_world_uuid UUID,
  p_name TEXT,
  p_uri TEXT,
  p_byteLength INTEGER,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create buffer entries';
  END IF;

  INSERT INTO buffers (
    vircadia_world_uuid, name, uri, byteLength, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_name, p_uri, p_byteLength, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_buffer(
  p_vircadia_uuid UUID,
  p_name TEXT DEFAULT NULL,
  p_uri TEXT DEFAULT NULL,
  p_byteLength INTEGER DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update buffer entries';
  END IF;

  UPDATE buffers
  SET 
    name = COALESCE(p_name, name),
    uri = COALESCE(p_uri, uri),
    byteLength = COALESCE(p_byteLength, byteLength),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_buffer(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete buffer entries';
  END IF;

  DELETE FROM buffers WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for buffers
CREATE POLICY buffers_select_policy ON buffers FOR SELECT USING (true);
CREATE POLICY buffers_insert_policy ON buffers FOR INSERT WITH CHECK (is_admin());
CREATE POLICY buffers_update_policy ON buffers FOR UPDATE USING (is_admin());
CREATE POLICY buffers_delete_policy ON buffers FOR DELETE USING (is_admin());

-- Buffer Views

CREATE OR REPLACE FUNCTION create_buffer_view(
  p_vircadia_world_uuid UUID,
  p_buffer TEXT,
  p_byteOffset INTEGER,
  p_byteLength INTEGER,
  p_byteStride INTEGER,
  p_target TEXT,
  p_name TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create buffer view entries';
  END IF;

  INSERT INTO buffer_views (
    vircadia_world_uuid, buffer, byteOffset, byteLength, byteStride, target, name, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_buffer, p_byteOffset, p_byteLength, p_byteStride, p_target, p_name, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_buffer_view(
  p_vircadia_uuid UUID,
  p_buffer TEXT DEFAULT NULL,
  p_byteOffset INTEGER DEFAULT NULL,
  p_byteLength INTEGER DEFAULT NULL,
  p_byteStride INTEGER DEFAULT NULL,
  p_target TEXT DEFAULT NULL,
  p_name TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update buffer view entries';
  END IF;

  UPDATE buffer_views
  SET 
    buffer = COALESCE(p_buffer, buffer),
    byteOffset = COALESCE(p_byteOffset, byteOffset),
    byteLength = COALESCE(p_byteLength, byteLength),
    byteStride = COALESCE(p_byteStride, byteStride),
    target = COALESCE(p_target, target),
    name = COALESCE(p_name, name),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_buffer_view(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete buffer view entries';
  END IF;

  DELETE FROM buffer_views WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for buffer_views
CREATE POLICY buffer_views_select_policy ON buffer_views FOR SELECT USING (true);
CREATE POLICY buffer_views_insert_policy ON buffer_views FOR INSERT WITH CHECK (is_admin());
CREATE POLICY buffer_views_update_policy ON buffer_views FOR UPDATE USING (is_admin());
CREATE POLICY buffer_views_delete_policy ON buffer_views FOR DELETE USING (is_admin());

-- Accessors

CREATE OR REPLACE FUNCTION create_accessor(
  p_vircadia_world_uuid UUID,
  p_bufferView TEXT,
  p_byteOffset INTEGER,
  p_componentType TEXT,
  p_normalized BOOLEAN,
  p_count INTEGER,
  p_type TEXT,
  p_max NUMERIC[],
  p_min NUMERIC[],
  p_sparse JSONB,
  p_name TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create accessor entries';
  END IF;

  INSERT INTO accessors (
    vircadia_world_uuid, bufferView, byteOffset, componentType, normalized, count, type, max, min, sparse,
    name, extensions, extras,  vircadia_version, vircadia_babylonjs_lod_mode,
    vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size,
    vircadia_babylonjs_lod_hide, vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap,
    vircadia_babylonjs_light_level, vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord,
    vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_mode,
    vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_bufferView, p_byteOffset, p_componentType, p_normalized, p_count, p_type, p_max, p_min, p_sparse,
    p_name, p_extensions, p_extras, p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode,
    p_vircadia_babylonjs_lod_auto, p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size,
    p_vircadia_babylonjs_lod_hide, p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap,
    p_vircadia_babylonjs_light_level, p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord,
    p_vircadia_babylonjs_light_use_as_shadowmap, p_vircadia_babylonjs_light_mode,
    p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_accessor(
  p_vircadia_uuid UUID,
  p_bufferView TEXT DEFAULT NULL,
  p_byteOffset INTEGER DEFAULT NULL,
  p_componentType TEXT DEFAULT NULL,
  p_normalized BOOLEAN DEFAULT NULL,
  p_count INTEGER DEFAULT NULL,
  p_type TEXT DEFAULT NULL,
  p_max NUMERIC[] DEFAULT NULL,
  p_min NUMERIC[] DEFAULT NULL,
  p_sparse JSONB DEFAULT NULL,
  p_name TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update accessor entries';
  END IF;

  UPDATE accessors
  SET 
    bufferView = COALESCE(p_bufferView, bufferView),
    byteOffset = COALESCE(p_byteOffset, byteOffset),
    componentType = COALESCE(p_componentType, componentType),
    normalized = COALESCE(p_normalized, normalized),
    count = COALESCE(p_count, count),
    type = COALESCE(p_type, type),
    max = COALESCE(p_max, max),
    min = COALESCE(p_min, min),
    sparse = COALESCE(p_sparse, sparse),
    name = COALESCE(p_name, name),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_accessor(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete accessor entries';
  END IF;

  DELETE FROM accessors WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for accessors
CREATE POLICY accessors_select_policy ON accessors FOR SELECT USING (true);
CREATE POLICY accessors_insert_policy ON accessors FOR INSERT WITH CHECK (is_admin());
CREATE POLICY accessors_update_policy ON accessors FOR UPDATE USING (is_admin());
CREATE POLICY accessors_delete_policy ON accessors FOR DELETE USING (is_admin());

-- Animations

CREATE OR REPLACE FUNCTION create_animation(
  p_vircadia_world_uuid UUID,
  p_channels JSONB,
  p_samplers JSONB,
  p_name TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create animation entries';
  END IF;

  INSERT INTO animations (
    vircadia_world_uuid, channels, samplers, name, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_channels, p_samplers, p_name, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_animation(
  p_vircadia_uuid UUID,
  p_channels JSONB DEFAULT NULL,
  p_samplers JSONB DEFAULT NULL,
  p_name TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update animation entries';
  END IF;

  UPDATE animations
  SET 
    channels = COALESCE(p_channels, channels),
    samplers = COALESCE(p_samplers, samplers),
    name = COALESCE(p_name, name),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_animation(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete animation entries';
  END IF;

  DELETE FROM animations WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for animations
CREATE POLICY animations_select_policy ON animations FOR SELECT USING (true);
CREATE POLICY animations_insert_policy ON animations FOR INSERT WITH CHECK (is_admin());
CREATE POLICY animations_update_policy ON animations FOR UPDATE USING (is_admin());
CREATE POLICY animations_delete_policy ON animations FOR DELETE USING (is_admin());

-- Cameras

CREATE OR REPLACE FUNCTION create_camera(
  p_vircadia_world_uuid UUID,
  p_orthographic JSONB,
  p_perspective JSONB,
  p_type TEXT,
  p_name TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create camera entries';
  END IF;

  INSERT INTO cameras (
    vircadia_world_uuid, orthographic, perspective, type, name, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_orthographic, p_perspective, p_type, p_name, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_camera(
  p_vircadia_uuid UUID,
  p_orthographic JSONB DEFAULT NULL,
  p_perspective JSONB DEFAULT NULL,
  p_type TEXT DEFAULT NULL,
  p_name TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update camera entries';
  END IF;

  UPDATE cameras
  SET 
    orthographic = COALESCE(p_orthographic, orthographic),
    perspective = COALESCE(p_perspective, perspective),
    type = COALESCE(p_type, type),
    name = COALESCE(p_name, name),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_camera(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete camera entries';
  END IF;

  DELETE FROM cameras WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for cameras
CREATE POLICY cameras_select_policy ON cameras FOR SELECT USING (true);
CREATE POLICY cameras_insert_policy ON cameras FOR INSERT WITH CHECK (is_admin());
CREATE POLICY cameras_update_policy ON cameras FOR UPDATE USING (is_admin());
CREATE POLICY cameras_delete_policy ON cameras FOR DELETE USING (is_admin());

-- Skins

CREATE OR REPLACE FUNCTION create_skin(
  p_vircadia_world_uuid UUID,
  p_inverseBindMatrices TEXT,
  p_skeleton TEXT,
  p_joints TEXT[],
  p_name TEXT,
  p_extensions JSONB,
  p_extras JSONB,
  p_vircadia_name TEXT,
  p_vircadia_version TEXT,
  p_vircadia_babylonjs_lod_mode TEXT,
  p_vircadia_babylonjs_lod_auto BOOLEAN,
  p_vircadia_babylonjs_lod_distance NUMERIC,
  p_vircadia_babylonjs_lod_size NUMERIC,
  p_vircadia_babylonjs_lod_hide NUMERIC,
  p_vircadia_babylonjs_billboard_mode INTEGER,
  p_vircadia_babylonjs_light_lightmap TEXT,
  p_vircadia_babylonjs_light_level NUMERIC,
  p_vircadia_babylonjs_light_color_space TEXT,
  p_vircadia_babylonjs_light_texcoord INTEGER,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN,
  p_vircadia_babylonjs_light_mode TEXT,
  p_vircadia_babylonjs_script_agent_scripts TEXT[],
  p_vircadia_babylonjs_script_persistent_scripts TEXT[]
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create skin entries';
  END IF;

  INSERT INTO skins (
    vircadia_world_uuid, inverseBindMatrices, skeleton, joints, name, extensions, extras,
     vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_inverseBindMatrices, p_skeleton, p_joints, p_name, p_extensions, p_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_skin(
  p_vircadia_uuid UUID,
  p_inverseBindMatrices TEXT DEFAULT NULL,
  p_skeleton TEXT DEFAULT NULL,
  p_joints TEXT[] DEFAULT NULL,
  p_name TEXT DEFAULT NULL,
  p_extensions JSONB DEFAULT NULL,
  p_extras JSONB DEFAULT NULL,
  p_vircadia_name TEXT DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_lod_auto BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_lod_distance NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_size NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_lod_hide NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_billboard_mode INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_lightmap TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_level NUMERIC DEFAULT NULL,
  p_vircadia_babylonjs_light_color_space TEXT DEFAULT NULL,
  p_vircadia_babylonjs_light_texcoord INTEGER DEFAULT NULL,
  p_vircadia_babylonjs_light_use_as_shadowmap BOOLEAN DEFAULT NULL,
  p_vircadia_babylonjs_light_mode TEXT DEFAULT NULL,
  p_vircadia_babylonjs_script_agent_scripts TEXT[] DEFAULT NULL,
  p_vircadia_babylonjs_script_persistent_scripts TEXT[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update skin entries';
  END IF;

  UPDATE skins
  SET 
    inverseBindMatrices = COALESCE(p_inverseBindMatrices, inverseBindMatrices),
    skeleton = COALESCE(p_skeleton, skeleton),
    joints = COALESCE(p_joints, joints),
    name = COALESCE(p_name, name),
    extensions = COALESCE(p_extensions, extensions),
    extras = COALESCE(p_extras, extras),
    
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version),
    vircadia_babylonjs_lod_mode = COALESCE(p_vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_mode),
    vircadia_babylonjs_lod_auto = COALESCE(p_vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_auto),
    vircadia_babylonjs_lod_distance = COALESCE(p_vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_distance),
    vircadia_babylonjs_lod_size = COALESCE(p_vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_size),
    vircadia_babylonjs_lod_hide = COALESCE(p_vircadia_babylonjs_lod_hide, vircadia_babylonjs_lod_hide),
    vircadia_babylonjs_billboard_mode = COALESCE(p_vircadia_babylonjs_billboard_mode, vircadia_babylonjs_billboard_mode),
    vircadia_babylonjs_light_lightmap = COALESCE(p_vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_lightmap),
    vircadia_babylonjs_light_level = COALESCE(p_vircadia_babylonjs_light_level, vircadia_babylonjs_light_level),
    vircadia_babylonjs_light_color_space = COALESCE(p_vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_color_space),
    vircadia_babylonjs_light_texcoord = COALESCE(p_vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_texcoord),
    vircadia_babylonjs_light_use_as_shadowmap = COALESCE(p_vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_use_as_shadowmap),
    vircadia_babylonjs_light_mode = COALESCE(p_vircadia_babylonjs_light_mode, vircadia_babylonjs_light_mode),
    vircadia_babylonjs_script_agent_scripts = COALESCE(p_vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_agent_scripts),
    vircadia_babylonjs_script_persistent_scripts = COALESCE(p_vircadia_babylonjs_script_persistent_scripts, vircadia_babylonjs_script_persistent_scripts)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_skin(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete skin entries';
  END IF;

  DELETE FROM skins WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- RLS for skins
CREATE POLICY skins_select_policy ON skins FOR SELECT USING (true);
CREATE POLICY skins_insert_policy ON skins FOR INSERT WITH CHECK (is_admin());
CREATE POLICY skins_update_policy ON skins FOR UPDATE USING (is_admin());
CREATE POLICY skins_delete_policy ON skins FOR DELETE USING (is_admin());