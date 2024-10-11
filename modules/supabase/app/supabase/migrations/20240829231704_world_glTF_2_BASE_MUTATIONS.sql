-- World GLTF

CREATE OR REPLACE FUNCTION create_world_gltf(
  p_gltf_name TEXT,
  p_gltf_version TEXT,
  p_gltf_metadata JSONB,
  p_gltf_scene TEXT,
  p_gltf_extensionsUsed TEXT[],
  p_gltf_extensionsRequired TEXT[],
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
  p_gltf_asset JSONB,
  p_vircadia_version TEXT
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT (is_admin()) THEN
    RAISE EXCEPTION 'Only admins can create world_gltf entries';
  END IF;

  INSERT INTO world_gltf (gltf_name, gltf_version, gltf_metadata, gltf_defaultScene, gltf_extensionsUsed, gltf_extensionsRequired, gltf_extensions, gltf_extras, gltf_asset, vircadia_version)
  VALUES (p_gltf_name, p_gltf_version, p_gltf_metadata, p_gltf_scene, p_gltf_extensionsUsed, p_gltf_extensionsRequired, p_gltf_extensions, p_gltf_extras, p_gltf_asset, p_vircadia_version)
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_version TEXT DEFAULT NULL,
  p_gltf_metadata JSONB DEFAULT NULL,
  p_gltf_defaultScene TEXT DEFAULT NULL,
  p_gltf_extensionsUsed TEXT[] DEFAULT NULL,
  p_gltf_extensionsRequired TEXT[] DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
  p_gltf_asset JSONB DEFAULT NULL,
  p_vircadia_version TEXT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf entries';
  END IF;

  UPDATE world_gltf
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_version = COALESCE(p_gltf_version, gltf_version),
    gltf_metadata = COALESCE(p_gltf_metadata, gltf_metadata),
    gltf_defaultScene = COALESCE(p_gltf_defaultScene, gltf_defaultScene),
    gltf_extensionsUsed = COALESCE(p_gltf_extensionsUsed, gltf_extensionsUsed),
    gltf_extensionsRequired = COALESCE(p_gltf_extensionsRequired, gltf_extensionsRequired),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    gltf_asset = COALESCE(p_gltf_asset, gltf_asset),
    vircadia_version = COALESCE(p_vircadia_version, vircadia_version)
  WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT (is_admin()) THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf entries';
  END IF;

  DELETE FROM world_gltf WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf
CREATE POLICY world_gltf_select_policy ON world_gltf FOR SELECT USING (true);
CREATE POLICY world_gltf_insert_policy ON world_gltf FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_update_policy ON world_gltf FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_delete_policy ON world_gltf FOR DELETE USING (is_admin());

-- Scenes

CREATE OR REPLACE FUNCTION create_world_gltf_scene(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_nodes JSONB,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_scenes (
    vircadia_world_uuid, gltf_name, gltf_nodes, gltf_extensions, gltf_extras,
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
    p_vircadia_world_uuid, p_gltf_name, p_gltf_nodes, p_gltf_extensions, p_gltf_extras,
    p_vircadia_version,
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_scene(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_nodes JSONB DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_scenes
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_nodes = COALESCE(p_gltf_nodes, gltf_nodes),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_scene(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete scene entries';
  END IF;

  DELETE FROM world_gltf_scenes WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_scenes
CREATE POLICY world_gltf_scenes_select_policy ON world_gltf_scenes FOR SELECT USING (true);
CREATE POLICY world_gltf_scenes_insert_policy ON world_gltf_scenes FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_scenes_update_policy ON world_gltf_scenes FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_scenes_delete_policy ON world_gltf_scenes FOR DELETE USING (is_admin());

-- Nodes

CREATE OR REPLACE FUNCTION create_world_gltf_node(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_camera TEXT,
  p_gltf_children JSONB,
  p_gltf_skin TEXT,
  p_gltf_matrix NUMERIC[16],
  p_gltf_mesh TEXT,
  p_gltf_rotation NUMERIC[4],
  p_gltf_scale NUMERIC[3],
  p_gltf_translation NUMERIC[3],
  p_gltf_weights JSONB,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_nodes (
    vircadia_world_uuid, gltf_name, gltf_camera, gltf_children, gltf_skin, gltf_matrix, gltf_mesh, gltf_rotation, gltf_scale, gltf_translation, gltf_weights, gltf_extensions, gltf_extras,
    vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_distance,
    vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide, vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap,
    vircadia_babylonjs_light_level, vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord,
    vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts,
    vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_name, p_gltf_camera, p_gltf_children, p_gltf_skin, p_gltf_matrix, p_gltf_mesh, p_gltf_rotation, p_gltf_scale, p_gltf_translation, p_gltf_weights,
    p_gltf_extensions, p_gltf_extras, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide, p_vircadia_babylonjs_billboard_mode,
    p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level, p_vircadia_babylonjs_light_color_space,
    p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap, p_vircadia_babylonjs_light_mode,
    p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_node(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_camera TEXT DEFAULT NULL,
  p_gltf_children JSONB DEFAULT NULL,
  p_gltf_skin TEXT DEFAULT NULL,
  p_gltf_matrix NUMERIC[16] DEFAULT NULL,
  p_gltf_mesh TEXT DEFAULT NULL,
  p_gltf_rotation NUMERIC[4] DEFAULT NULL,
  p_gltf_scale NUMERIC[3] DEFAULT NULL,
  p_gltf_translation NUMERIC[3] DEFAULT NULL,
  p_gltf_weights JSONB DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_nodes
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_camera = COALESCE(p_gltf_camera, gltf_camera),
    gltf_children = COALESCE(p_gltf_children, gltf_children),
    gltf_skin = COALESCE(p_gltf_skin, gltf_skin),
    gltf_matrix = COALESCE(p_gltf_matrix, gltf_matrix),
    gltf_mesh = COALESCE(p_gltf_mesh, gltf_mesh),
    gltf_rotation = COALESCE(p_gltf_rotation, gltf_rotation),
    gltf_scale = COALESCE(p_gltf_scale, gltf_scale),
    gltf_translation = COALESCE(p_gltf_translation, gltf_translation),
    gltf_weights = COALESCE(p_gltf_weights, gltf_weights),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_node(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete node entries';
  END IF;

  DELETE FROM world_gltf_nodes WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_nodes
CREATE POLICY world_gltf_nodes_select_policy ON world_gltf_nodes FOR SELECT USING (true);
CREATE POLICY world_gltf_nodes_insert_policy ON world_gltf_nodes FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_nodes_update_policy ON world_gltf_nodes FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_nodes_delete_policy ON world_gltf_nodes FOR DELETE USING (is_admin());

-- Meshes

CREATE OR REPLACE FUNCTION create_world_gltf_mesh(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_primitives JSONB,
  p_gltf_weights JSONB,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_meshes (
    vircadia_world_uuid, gltf_name, gltf_primitives, gltf_weights, gltf_extensions, gltf_extras,
    vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_name, p_gltf_primitives, p_gltf_weights, p_gltf_extensions, p_gltf_extras,
    p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_mesh(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_primitives JSONB DEFAULT NULL,
  p_gltf_weights JSONB DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_meshes
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_primitives = COALESCE(p_gltf_primitives, gltf_primitives),
    gltf_weights = COALESCE(p_gltf_weights, gltf_weights),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_mesh(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete mesh entries';
  END IF;

  DELETE FROM world_gltf_meshes WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_meshes
CREATE POLICY world_gltf_meshes_select_policy ON world_gltf_meshes FOR SELECT USING (true);
CREATE POLICY world_gltf_meshes_insert_policy ON world_gltf_meshes FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_meshes_update_policy ON world_gltf_meshes FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_meshes_delete_policy ON world_gltf_meshes FOR DELETE USING (is_admin());

-- Materials

CREATE OR REPLACE FUNCTION create_world_gltf_material(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_pbrMetallicRoughness JSONB,
  p_gltf_normalTexture JSONB,
  p_gltf_occlusionTexture JSONB,
  p_gltf_emissiveTexture JSONB,
  p_gltf_emissiveFactor NUMERIC[3],
  p_gltf_alphaMode TEXT,
  p_gltf_alphaCutoff NUMERIC,
  p_gltf_doubleSided BOOLEAN,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_materials (
    vircadia_world_uuid, gltf_name, gltf_pbrMetallicRoughness, gltf_normalTexture, gltf_occlusionTexture, gltf_emissiveTexture,
    gltf_emissiveFactor, gltf_alphaMode, gltf_alphaCutoff, gltf_doubleSided, gltf_extensions, gltf_extras,
    vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_name, p_gltf_pbrMetallicRoughness, p_gltf_normalTexture, p_gltf_occlusionTexture, p_gltf_emissiveTexture,
    p_gltf_emissiveFactor, p_gltf_alphaMode, p_gltf_alphaCutoff, p_gltf_doubleSided, p_gltf_extensions, p_gltf_extras,
    p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_material(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_pbrMetallicRoughness JSONB DEFAULT NULL,
  p_gltf_normalTexture JSONB DEFAULT NULL,
  p_gltf_occlusionTexture JSONB DEFAULT NULL,
  p_gltf_emissiveTexture JSONB DEFAULT NULL,
  p_gltf_emissiveFactor NUMERIC[3] DEFAULT NULL,
  p_gltf_alphaMode TEXT DEFAULT NULL,
  p_gltf_alphaCutoff NUMERIC DEFAULT NULL,
  p_gltf_doubleSided BOOLEAN DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_materials
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_pbrMetallicRoughness = COALESCE(p_gltf_pbrMetallicRoughness, gltf_pbrMetallicRoughness),
    gltf_normalTexture = COALESCE(p_gltf_normalTexture, gltf_normalTexture),
    gltf_occlusionTexture = COALESCE(p_gltf_occlusionTexture, gltf_occlusionTexture),
    gltf_emissiveTexture = COALESCE(p_gltf_emissiveTexture, gltf_emissiveTexture),
    gltf_emissiveFactor = COALESCE(p_gltf_emissiveFactor, gltf_emissiveFactor),
    gltf_alphaMode = COALESCE(p_gltf_alphaMode, gltf_alphaMode),
    gltf_alphaCutoff = COALESCE(p_gltf_alphaCutoff, gltf_alphaCutoff),
    gltf_doubleSided = COALESCE(p_gltf_doubleSided, gltf_doubleSided),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_material(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete material entries';
  END IF;

  DELETE FROM world_gltf_materials WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_materials
CREATE POLICY world_gltf_materials_select_policy ON world_gltf_materials FOR SELECT USING (true);
CREATE POLICY world_gltf_materials_insert_policy ON world_gltf_materials FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_materials_update_policy ON world_gltf_materials FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_materials_delete_policy ON world_gltf_materials FOR DELETE USING (is_admin());

-- Textures

CREATE OR REPLACE FUNCTION create_world_gltf_texture(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_sampler TEXT,
  p_gltf_source TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_textures (
    vircadia_world_uuid, gltf_name, gltf_sampler, gltf_source, gltf_extensions, gltf_extras,
    vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_name, p_gltf_sampler, p_gltf_source, p_gltf_extensions, p_gltf_extras,
    p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_texture(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_sampler TEXT DEFAULT NULL,
  p_gltf_source TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_textures
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_sampler = COALESCE(p_gltf_sampler, gltf_sampler),
    gltf_source = COALESCE(p_gltf_source, gltf_source),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_texture(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete texture entries';
  END IF;

  DELETE FROM world_gltf_textures WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_textures
CREATE POLICY world_gltf_textures_select_policy ON world_gltf_textures FOR SELECT USING (true);
CREATE POLICY world_gltf_textures_insert_policy ON world_gltf_textures FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_textures_update_policy ON world_gltf_textures FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_textures_delete_policy ON world_gltf_textures FOR DELETE USING (is_admin());

-- Images

CREATE OR REPLACE FUNCTION create_world_gltf_image(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_uri TEXT,
  p_gltf_mimeType TEXT,
  p_gltf_bufferView TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_images (
    vircadia_world_uuid, gltf_name, gltf_uri, gltf_mimeType, gltf_bufferView, gltf_extensions, gltf_extras,
    vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_name, p_gltf_uri, p_gltf_mimeType, p_gltf_bufferView, p_gltf_extensions, p_gltf_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_image(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_uri TEXT DEFAULT NULL,
  p_gltf_mimeType TEXT DEFAULT NULL,
  p_gltf_bufferView TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_images
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_uri = COALESCE(p_gltf_uri, gltf_uri),
    gltf_mimeType = COALESCE(p_gltf_mimeType, gltf_mimeType),
    gltf_bufferView = COALESCE(p_gltf_bufferView, gltf_bufferView),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_image(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete image entries';
  END IF;

  DELETE FROM world_gltf_images WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_images
CREATE POLICY world_gltf_images_select_policy ON world_gltf_images FOR SELECT USING (true);
CREATE POLICY world_gltf_images_insert_policy ON world_gltf_images FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_images_update_policy ON world_gltf_images FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_images_delete_policy ON world_gltf_images FOR DELETE USING (is_admin());

-- Samplers

CREATE OR REPLACE FUNCTION create_world_gltf_sampler(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_magFilter TEXT,
  p_gltf_minFilter TEXT,
  p_gltf_wrapS TEXT,
  p_gltf_wrapT TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_samplers (
    vircadia_world_uuid, gltf_name, gltf_magFilter, gltf_minFilter, gltf_wrapS, gltf_wrapT, gltf_extensions, gltf_extras,
    vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_name, p_gltf_magFilter, p_gltf_minFilter, p_gltf_wrapS, p_gltf_wrapT, p_gltf_extensions, p_gltf_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_sampler(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_magFilter TEXT DEFAULT NULL,
  p_gltf_minFilter TEXT DEFAULT NULL,
  p_gltf_wrapS TEXT DEFAULT NULL,
  p_gltf_wrapT TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_samplers
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_magFilter = COALESCE(p_gltf_magFilter, gltf_magFilter),
    gltf_minFilter = COALESCE(p_gltf_minFilter, gltf_minFilter),
    gltf_wrapS = COALESCE(p_gltf_wrapS, gltf_wrapS),
    gltf_wrapT = COALESCE(p_gltf_wrapT, gltf_wrapT),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_sampler(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete sampler entries';
  END IF;

  DELETE FROM world_gltf_samplers WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_samplers
CREATE POLICY world_gltf_samplers_select_policy ON world_gltf_samplers FOR SELECT USING (true);
CREATE POLICY world_gltf_samplers_insert_policy ON world_gltf_samplers FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_samplers_update_policy ON world_gltf_samplers FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_samplers_delete_policy ON world_gltf_samplers FOR DELETE USING (is_admin());

-- Buffers

CREATE OR REPLACE FUNCTION create_world_gltf_buffer(
  p_vircadia_world_uuid UUID,
  p_gltf_name TEXT,
  p_gltf_uri TEXT,
  p_gltf_byteLength INTEGER,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_buffers (
    vircadia_world_uuid, gltf_name, gltf_uri, gltf_byteLength, gltf_extensions, gltf_extras,
    vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_name, p_gltf_uri, p_gltf_byteLength, p_gltf_extensions, p_gltf_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_buffer(
  p_vircadia_uuid UUID,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_uri TEXT DEFAULT NULL,
  p_gltf_byteLength INTEGER DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_buffers
  SET 
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_uri = COALESCE(p_gltf_uri, gltf_uri),
    gltf_byteLength = COALESCE(p_gltf_byteLength, gltf_byteLength),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_buffer(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete buffer entries';
  END IF;

  DELETE FROM world_gltf_buffers WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_buffers
CREATE POLICY world_gltf_buffers_select_policy ON world_gltf_buffers FOR SELECT USING (true);
CREATE POLICY world_gltf_buffers_insert_policy ON world_gltf_buffers FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_buffers_update_policy ON world_gltf_buffers FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_buffers_delete_policy ON world_gltf_buffers FOR DELETE USING (is_admin());

-- Buffer Views

CREATE OR REPLACE FUNCTION create_world_gltf_buffer_view(
  p_vircadia_world_uuid UUID,
  p_gltf_buffer TEXT,
  p_gltf_byteOffset INTEGER,
  p_gltf_byteLength INTEGER,
  p_gltf_byteStride INTEGER,
  p_gltf_target TEXT,
  p_gltf_name TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_buffer_views (
    vircadia_world_uuid, gltf_buffer, gltf_byteOffset, gltf_byteLength, gltf_byteStride, gltf_target, gltf_name, gltf_extensions, gltf_extras,
    vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_buffer, p_gltf_byteOffset, p_gltf_byteLength, p_gltf_byteStride, p_gltf_target, p_gltf_name, p_gltf_extensions, p_gltf_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_buffer_view(
  p_vircadia_uuid UUID,
  p_gltf_buffer TEXT DEFAULT NULL,
  p_gltf_byteOffset INTEGER DEFAULT NULL,
  p_gltf_byteLength INTEGER DEFAULT NULL,
  p_gltf_byteStride INTEGER DEFAULT NULL,
  p_gltf_target TEXT DEFAULT NULL,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_buffer_views
  SET 
    gltf_buffer = COALESCE(p_gltf_buffer, gltf_buffer),
    gltf_byteOffset = COALESCE(p_gltf_byteOffset, gltf_byteOffset),
    gltf_byteLength = COALESCE(p_gltf_byteLength, gltf_byteLength),
    gltf_byteStride = COALESCE(p_gltf_byteStride, gltf_byteStride),
    gltf_target = COALESCE(p_gltf_target, gltf_target),
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_buffer_view(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete buffer view entries';
  END IF;

  DELETE FROM world_gltf_buffer_views WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_buffer_views
CREATE POLICY world_gltf_buffer_views_select_policy ON world_gltf_buffer_views FOR SELECT USING (true);
CREATE POLICY world_gltf_buffer_views_insert_policy ON world_gltf_buffer_views FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_buffer_views_update_policy ON world_gltf_buffer_views FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_buffer_views_delete_policy ON world_gltf_buffer_views FOR DELETE USING (is_admin());

-- Accessors

CREATE OR REPLACE FUNCTION create_world_gltf_accessor(
  p_vircadia_world_uuid UUID,
  p_gltf_bufferView TEXT,
  p_gltf_byteOffset INTEGER,
  p_gltf_componentType TEXT,
  p_gltf_normalized BOOLEAN,
  p_gltf_count INTEGER,
  p_gltf_type TEXT,
  p_gltf_max NUMERIC[],
  p_gltf_min NUMERIC[],
  p_gltf_sparse JSONB,
  p_gltf_name TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_accessors (
    vircadia_world_uuid, gltf_bufferView, gltf_byteOffset, gltf_componentType, gltf_normalized, gltf_count, gltf_type, gltf_max, gltf_min, gltf_sparse,
    gltf_name, gltf_extensions, gltf_extras, vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode,
    vircadia_babylonjs_lod_auto, vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size,
    vircadia_babylonjs_lod_hide, vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap,
    vircadia_babylonjs_light_level, vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord,
    vircadia_babylonjs_light_use_as_shadowmap, vircadia_babylonjs_light_mode,
    vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_bufferView, p_gltf_byteOffset, p_gltf_componentType, p_gltf_normalized, p_gltf_count, p_gltf_type, p_gltf_max, p_gltf_min, p_gltf_sparse,
    p_gltf_name, p_gltf_extensions, p_gltf_extras, p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode,
    p_vircadia_babylonjs_lod_auto, p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size,
    p_vircadia_babylonjs_lod_hide, p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap,
    p_vircadia_babylonjs_light_level, p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord,
    p_vircadia_babylonjs_light_use_as_shadowmap, p_vircadia_babylonjs_light_mode,
    p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_accessor(
  p_vircadia_uuid UUID,
  p_gltf_bufferView TEXT DEFAULT NULL,
  p_gltf_byteOffset INTEGER DEFAULT NULL,
  p_gltf_componentType TEXT DEFAULT NULL,
  p_gltf_normalized BOOLEAN DEFAULT NULL,
  p_gltf_count INTEGER DEFAULT NULL,
  p_gltf_type TEXT DEFAULT NULL,
  p_gltf_max NUMERIC[] DEFAULT NULL,
  p_gltf_min NUMERIC[] DEFAULT NULL,
  p_gltf_sparse JSONB DEFAULT NULL,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_accessors
  SET 
    gltf_bufferView = COALESCE(p_gltf_bufferView, gltf_bufferView),
    gltf_byteOffset = COALESCE(p_gltf_byteOffset, gltf_byteOffset),
    gltf_componentType = COALESCE(p_gltf_componentType, gltf_componentType),
    gltf_normalized = COALESCE(p_gltf_normalized, gltf_normalized),
    gltf_count = COALESCE(p_gltf_count, gltf_count),
    gltf_type = COALESCE(p_gltf_type, gltf_type),
    gltf_max = COALESCE(p_gltf_max, gltf_max),
    gltf_min = COALESCE(p_gltf_min, gltf_min),
    gltf_sparse = COALESCE(p_gltf_sparse, gltf_sparse),
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_accessor(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete accessor entries';
  END IF;

  DELETE FROM world_gltf_accessors WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_accessors
CREATE POLICY world_gltf_accessors_select_policy ON world_gltf_accessors FOR SELECT USING (true);
CREATE POLICY world_gltf_accessors_insert_policy ON world_gltf_accessors FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_accessors_update_policy ON world_gltf_accessors FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_accessors_delete_policy ON world_gltf_accessors FOR DELETE USING (is_admin());

-- Animations

CREATE OR REPLACE FUNCTION create_world_gltf_animation(
  p_vircadia_world_uuid UUID,
  p_gltf_channels JSONB,
  p_gltf_samplers JSONB,
  p_gltf_name TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_animations (
    vircadia_world_uuid, gltf_channels, gltf_samplers, gltf_name, gltf_extensions, gltf_extras,
    vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_channels, p_gltf_samplers, p_gltf_name, p_gltf_extensions, p_gltf_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_animation(
  p_vircadia_uuid UUID,
  p_gltf_channels JSONB DEFAULT NULL,
  p_gltf_samplers JSONB DEFAULT NULL,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_animations
  SET 
    gltf_channels = COALESCE(p_gltf_channels, gltf_channels),
    gltf_samplers = COALESCE(p_gltf_samplers, gltf_samplers),
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_animation(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete animation entries';
  END IF;

  DELETE FROM world_gltf_animations WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_animations
CREATE POLICY world_gltf_animations_select_policy ON world_gltf_animations FOR SELECT USING (true);
CREATE POLICY world_gltf_animations_insert_policy ON world_gltf_animations FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_animations_update_policy ON world_gltf_animations FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_animations_delete_policy ON world_gltf_animations FOR DELETE USING (is_admin());

-- Cameras

CREATE OR REPLACE FUNCTION create_world_gltf_camera(
  p_vircadia_world_uuid UUID,
  p_gltf_orthographic JSONB,
  p_gltf_perspective JSONB,
  p_gltf_type TEXT,
  p_gltf_name TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_cameras (
    vircadia_world_uuid, gltf_orthographic, gltf_perspective, gltf_type, gltf_name, gltf_extensions, gltf_extras,
    vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_orthographic, p_gltf_perspective, p_gltf_type, p_gltf_name, p_gltf_extensions, p_gltf_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_camera(
  p_vircadia_uuid UUID,
  p_gltf_orthographic JSONB DEFAULT NULL,
  p_gltf_perspective JSONB DEFAULT NULL,
  p_gltf_type TEXT DEFAULT NULL,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_cameras
  SET 
    gltf_orthographic = COALESCE(p_gltf_orthographic, gltf_orthographic),
    gltf_perspective = COALESCE(p_gltf_perspective, gltf_perspective),
    gltf_type = COALESCE(p_gltf_type, gltf_type),
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_camera(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete camera entries';
  END IF;

  DELETE FROM world_gltf_cameras WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_cameras
CREATE POLICY world_gltf_cameras_select_policy ON world_gltf_cameras FOR SELECT USING (true);
CREATE POLICY world_gltf_cameras_insert_policy ON world_gltf_cameras FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_cameras_update_policy ON world_gltf_cameras FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_cameras_delete_policy ON world_gltf_cameras FOR DELETE USING (is_admin());

-- Skins

CREATE OR REPLACE FUNCTION create_world_gltf_skin(
  p_vircadia_world_uuid UUID,
  p_gltf_inverseBindMatrices TEXT,
  p_gltf_skeleton TEXT,
  p_gltf_joints TEXT[],
  p_gltf_name TEXT,
  p_gltf_extensions JSONB,
  p_gltf_extras JSONB,
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

  INSERT INTO world_gltf_skins (
    vircadia_world_uuid, gltf_inverseBindMatrices, gltf_skeleton, gltf_joints, gltf_name, gltf_extensions, gltf_extras,
    vircadia_name, vircadia_version, vircadia_babylonjs_lod_mode, vircadia_babylonjs_lod_auto,
    vircadia_babylonjs_lod_distance, vircadia_babylonjs_lod_size, vircadia_babylonjs_lod_hide,
    vircadia_babylonjs_billboard_mode, vircadia_babylonjs_light_lightmap, vircadia_babylonjs_light_level,
    vircadia_babylonjs_light_color_space, vircadia_babylonjs_light_texcoord, vircadia_babylonjs_light_use_as_shadowmap,
    vircadia_babylonjs_light_mode, vircadia_babylonjs_script_agent_scripts, vircadia_babylonjs_script_persistent_scripts
  )
  VALUES (
    p_vircadia_world_uuid, p_gltf_inverseBindMatrices, p_gltf_skeleton, p_gltf_joints, p_gltf_name, p_gltf_extensions, p_gltf_extras,
    p_vircadia_name, p_vircadia_version, p_vircadia_babylonjs_lod_mode, p_vircadia_babylonjs_lod_auto,
    p_vircadia_babylonjs_lod_distance, p_vircadia_babylonjs_lod_size, p_vircadia_babylonjs_lod_hide,
    p_vircadia_babylonjs_billboard_mode, p_vircadia_babylonjs_light_lightmap, p_vircadia_babylonjs_light_level,
    p_vircadia_babylonjs_light_color_space, p_vircadia_babylonjs_light_texcoord, p_vircadia_babylonjs_light_use_as_shadowmap,
    p_vircadia_babylonjs_light_mode, p_vircadia_babylonjs_script_agent_scripts, p_vircadia_babylonjs_script_persistent_scripts
  )
  RETURNING vircadia_uuid INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_skin(
  p_vircadia_uuid UUID,
  p_gltf_inverseBindMatrices TEXT DEFAULT NULL,
  p_gltf_skeleton TEXT DEFAULT NULL,
  p_gltf_joints TEXT[] DEFAULT NULL,
  p_gltf_name TEXT DEFAULT NULL,
  p_gltf_extensions JSONB DEFAULT NULL,
  p_gltf_extras JSONB DEFAULT NULL,
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

  UPDATE world_gltf_skins
  SET 
    gltf_inverseBindMatrices = COALESCE(p_gltf_inverseBindMatrices, gltf_inverseBindMatrices),
    gltf_skeleton = COALESCE(p_gltf_skeleton, gltf_skeleton),
    gltf_joints = COALESCE(p_gltf_joints, gltf_joints),
    gltf_name = COALESCE(p_gltf_name, gltf_name),
    gltf_extensions = COALESCE(p_gltf_extensions, gltf_extensions),
    gltf_extras = COALESCE(p_gltf_extras, gltf_extras),
    vircadia_name = COALESCE(p_vircadia_name, vircadia_name),
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_skin(p_vircadia_uuid UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete skin entries';
  END IF;

  DELETE FROM world_gltf_skins WHERE vircadia_uuid = p_vircadia_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for world_gltf_skins
CREATE POLICY world_gltf_skins_select_policy ON world_gltf_skins FOR SELECT USING (true);
CREATE POLICY world_gltf_skins_insert_policy ON world_gltf_skins FOR INSERT WITH CHECK (is_admin());
CREATE POLICY world_gltf_skins_update_policy ON world_gltf_skins FOR UPDATE USING (is_admin());
CREATE POLICY world_gltf_skins_delete_policy ON world_gltf_skins FOR DELETE USING (is_admin());