-- World GLTF Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_metadata(
  p_world_gltf_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf metadata entries';
  END IF;

  INSERT INTO world_gltf_metadata (world_gltf_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_world_gltf_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf metadata entries';
  END IF;

  UPDATE world_gltf_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf metadata entries';
  END IF;

  DELETE FROM world_gltf_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Scenes Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_scene_metadata(
  p_scene_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_scene metadata entries';
  END IF;

  INSERT INTO world_gltf_scenes_metadata (scene_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_scene_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_scene_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_scene metadata entries';
  END IF;

  UPDATE world_gltf_scenes_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_scene_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_scene metadata entries';
  END IF;

  DELETE FROM world_gltf_scenes_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Nodes Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_node_metadata(
  p_node_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_node metadata entries';
  END IF;

  INSERT INTO world_gltf_nodes_metadata (node_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_node_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_node_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_node metadata entries';
  END IF;

  UPDATE world_gltf_nodes_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_node_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_node metadata entries';
  END IF;

  DELETE FROM world_gltf_nodes_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Meshes Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_mesh_metadata(
  p_mesh_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_mesh metadata entries';
  END IF;

  INSERT INTO world_gltf_meshes_metadata (mesh_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_mesh_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_mesh_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_mesh metadata entries';
  END IF;

  UPDATE world_gltf_meshes_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_mesh_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_mesh metadata entries';
  END IF;

  DELETE FROM world_gltf_meshes_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Materials Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_material_metadata(
  p_material_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_material metadata entries';
  END IF;

  INSERT INTO world_gltf_materials_metadata (material_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_material_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_material_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_material metadata entries';
  END IF;

  UPDATE world_gltf_materials_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_material_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_material metadata entries';
  END IF;

  DELETE FROM world_gltf_materials_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Textures Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_texture_metadata(
  p_texture_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_texture metadata entries';
  END IF;

  INSERT INTO world_gltf_textures_metadata (texture_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_texture_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_texture_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_texture metadata entries';
  END IF;

  UPDATE world_gltf_textures_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_texture_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_texture metadata entries';
  END IF;

  DELETE FROM world_gltf_textures_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Images Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_image_metadata(
  p_image_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_image metadata entries';
  END IF;

  INSERT INTO world_gltf_images_metadata (image_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_image_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_image_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_image metadata entries';
  END IF;

  UPDATE world_gltf_images_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_image_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_image metadata entries';
  END IF;

  DELETE FROM world_gltf_images_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Samplers Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_sampler_metadata(
  p_sampler_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_sampler metadata entries';
  END IF;

  INSERT INTO world_gltf_samplers_metadata (sampler_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_sampler_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_sampler_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_sampler metadata entries';
  END IF;

  UPDATE world_gltf_samplers_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_sampler_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_sampler metadata entries';
  END IF;

  DELETE FROM world_gltf_samplers_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Buffers Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_buffer_metadata(
  p_buffer_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_buffer metadata entries';
  END IF;

  INSERT INTO world_gltf_buffers_metadata (buffer_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_buffer_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_buffer_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_buffer metadata entries';
  END IF;

  UPDATE world_gltf_buffers_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_buffer_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_buffer metadata entries';
  END IF;

  DELETE FROM world_gltf_buffers_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Buffer Views Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_buffer_view_metadata(
  p_buffer_view_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_buffer_view metadata entries';
  END IF;

  INSERT INTO world_gltf_buffer_views_metadata (buffer_view_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_buffer_view_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_buffer_view_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_buffer_view metadata entries';
  END IF;

  UPDATE world_gltf_buffer_views_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_buffer_view_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_buffer_view metadata entries';
  END IF;

  DELETE FROM world_gltf_buffer_views_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Accessors Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_accessor_metadata(
  p_accessor_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_accessor metadata entries';
  END IF;

  INSERT INTO world_gltf_accessors_metadata (accessor_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_accessor_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_accessor_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_accessor metadata entries';
  END IF;

  UPDATE world_gltf_accessors_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_accessor_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_accessor metadata entries';
  END IF;

  DELETE FROM world_gltf_accessors_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Animations Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_animation_metadata(
  p_animation_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_animation metadata entries';
  END IF;

  INSERT INTO world_gltf_animations_metadata (animation_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_animation_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_animation_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_animation metadata entries';
  END IF;

  UPDATE world_gltf_animations_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_animation_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_animation metadata entries';
  END IF;

  DELETE FROM world_gltf_animations_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Skins Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_skin_metadata(
  p_skin_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_skin metadata entries';
  END IF;

  INSERT INTO world_gltf_skins_metadata (skin_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_skin_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_skin_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_skin metadata entries';
  END IF;

  UPDATE world_gltf_skins_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_skin_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_skin metadata entries';
  END IF;

  DELETE FROM world_gltf_skins_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Cameras Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_camera_metadata(
  p_camera_id UUID,
  p_key TEXT,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf_camera metadata entries';
  END IF;

  INSERT INTO world_gltf_cameras_metadata (camera_id, key, values_text, values_numeric, values_boolean, values_timestamp)
  VALUES (p_camera_id, p_key, p_values_text, p_values_numeric, p_values_boolean, p_values_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_world_gltf_camera_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_values_text TEXT[] DEFAULT NULL,
  p_values_numeric NUMERIC[] DEFAULT NULL,
  p_values_boolean BOOLEAN[] DEFAULT NULL,
  p_values_timestamp TIMESTAMPTZ[] DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf_camera metadata entries';
  END IF;

  UPDATE world_gltf_cameras_metadata
  SET 
    key = COALESCE(p_key, key),
    values_text = COALESCE(p_values_text, values_text),
    values_numeric = COALESCE(p_values_numeric, values_numeric),
    values_boolean = COALESCE(p_values_boolean, values_boolean),
    values_timestamp = COALESCE(p_values_timestamp, values_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_world_gltf_camera_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf_camera metadata entries';
  END IF;

  DELETE FROM world_gltf_cameras_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- World GLTF Metadata RLS
CREATE POLICY world_gltf_metadata_select_policy ON world_gltf_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf WHERE world_gltf.vircadia_uuid = world_gltf_metadata.world_gltf_id)
  );

CREATE POLICY world_gltf_metadata_insert_policy ON world_gltf_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf WHERE world_gltf.vircadia_uuid = world_gltf_metadata.world_gltf_id AND is_admin())
  );

CREATE POLICY world_gltf_metadata_update_policy ON world_gltf_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf WHERE world_gltf.vircadia_uuid = world_gltf_metadata.world_gltf_id AND is_admin())
  );

CREATE POLICY world_gltf_metadata_delete_policy ON world_gltf_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf WHERE world_gltf.vircadia_uuid = world_gltf_metadata.world_gltf_id AND is_admin())
  );

-- World GLTF Scenes Metadata RLS
CREATE POLICY world_gltf_scenes_metadata_select_policy ON world_gltf_scenes_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_scenes WHERE world_gltf_scenes.vircadia_uuid = world_gltf_scenes_metadata.scene_id)
  );

CREATE POLICY world_gltf_scenes_metadata_insert_policy ON world_gltf_scenes_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_scenes WHERE world_gltf_scenes.vircadia_uuid = world_gltf_scenes_metadata.scene_id AND is_admin())
  );

CREATE POLICY world_gltf_scenes_metadata_update_policy ON world_gltf_scenes_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_scenes WHERE world_gltf_scenes.vircadia_uuid = world_gltf_scenes_metadata.scene_id AND is_admin())
  );

CREATE POLICY world_gltf_scenes_metadata_delete_policy ON world_gltf_scenes_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_scenes WHERE world_gltf_scenes.vircadia_uuid = world_gltf_scenes_metadata.scene_id AND is_admin())
  );

-- World GLTF Nodes Metadata RLS
CREATE POLICY world_gltf_nodes_metadata_select_policy ON world_gltf_nodes_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_nodes WHERE world_gltf_nodes.vircadia_uuid = world_gltf_nodes_metadata.node_id)
  );

CREATE POLICY world_gltf_nodes_metadata_insert_policy ON world_gltf_nodes_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_nodes WHERE world_gltf_nodes.vircadia_uuid = world_gltf_nodes_metadata.node_id AND is_admin())
  );

CREATE POLICY world_gltf_nodes_metadata_update_policy ON world_gltf_nodes_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_nodes WHERE world_gltf_nodes.vircadia_uuid = world_gltf_nodes_metadata.node_id AND is_admin())
  );

CREATE POLICY world_gltf_nodes_metadata_delete_policy ON world_gltf_nodes_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_nodes WHERE world_gltf_nodes.vircadia_uuid = world_gltf_nodes_metadata.node_id AND is_admin())
  );

-- World GLTF Meshes Metadata RLS
CREATE POLICY world_gltf_meshes_metadata_select_policy ON world_gltf_meshes_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_meshes WHERE world_gltf_meshes.vircadia_uuid = world_gltf_meshes_metadata.mesh_id)
  );

CREATE POLICY world_gltf_meshes_metadata_insert_policy ON world_gltf_meshes_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_meshes WHERE world_gltf_meshes.vircadia_uuid = world_gltf_meshes_metadata.mesh_id AND is_admin())
  );

CREATE POLICY world_gltf_meshes_metadata_update_policy ON world_gltf_meshes_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_meshes WHERE world_gltf_meshes.vircadia_uuid = world_gltf_meshes_metadata.mesh_id AND is_admin())
  );

CREATE POLICY world_gltf_meshes_metadata_delete_policy ON world_gltf_meshes_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_meshes WHERE world_gltf_meshes.vircadia_uuid = world_gltf_meshes_metadata.mesh_id AND is_admin())
  );

-- World GLTF Materials Metadata RLS
CREATE POLICY world_gltf_materials_metadata_select_policy ON world_gltf_materials_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_materials WHERE world_gltf_materials.vircadia_uuid = world_gltf_materials_metadata.material_id)
  );

CREATE POLICY world_gltf_materials_metadata_insert_policy ON world_gltf_materials_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_materials WHERE world_gltf_materials.vircadia_uuid = world_gltf_materials_metadata.material_id AND is_admin())
  );

CREATE POLICY world_gltf_materials_metadata_update_policy ON world_gltf_materials_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_materials WHERE world_gltf_materials.vircadia_uuid = world_gltf_materials_metadata.material_id AND is_admin())
  );

CREATE POLICY world_gltf_materials_metadata_delete_policy ON world_gltf_materials_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_materials WHERE world_gltf_materials.vircadia_uuid = world_gltf_materials_metadata.material_id AND is_admin())
  );

-- World GLTF Textures Metadata RLS
CREATE POLICY world_gltf_textures_metadata_select_policy ON world_gltf_textures_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_textures WHERE world_gltf_textures.vircadia_uuid = world_gltf_textures_metadata.texture_id)
  );

CREATE POLICY world_gltf_textures_metadata_insert_policy ON world_gltf_textures_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_textures WHERE world_gltf_textures.vircadia_uuid = world_gltf_textures_metadata.texture_id AND is_admin())
  );

CREATE POLICY world_gltf_textures_metadata_update_policy ON world_gltf_textures_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_textures WHERE world_gltf_textures.vircadia_uuid = world_gltf_textures_metadata.texture_id AND is_admin())
  );

CREATE POLICY world_gltf_textures_metadata_delete_policy ON world_gltf_textures_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_textures WHERE world_gltf_textures.vircadia_uuid = world_gltf_textures_metadata.texture_id AND is_admin())
  );

-- World GLTF Images Metadata RLS
CREATE POLICY world_gltf_images_metadata_select_policy ON world_gltf_images_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_images WHERE world_gltf_images.vircadia_uuid = world_gltf_images_metadata.image_id)
  );

CREATE POLICY world_gltf_images_metadata_insert_policy ON world_gltf_images_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_images WHERE world_gltf_images.vircadia_uuid = world_gltf_images_metadata.image_id AND is_admin())
  );

CREATE POLICY world_gltf_images_metadata_update_policy ON world_gltf_images_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_images WHERE world_gltf_images.vircadia_uuid = world_gltf_images_metadata.image_id AND is_admin())
  );

CREATE POLICY world_gltf_images_metadata_delete_policy ON world_gltf_images_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_images WHERE world_gltf_images.vircadia_uuid = world_gltf_images_metadata.image_id AND is_admin())
  );

-- World GLTF Samplers Metadata RLS
CREATE POLICY world_gltf_samplers_metadata_select_policy ON world_gltf_samplers_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_samplers WHERE world_gltf_samplers.vircadia_uuid = world_gltf_samplers_metadata.sampler_id)
  );

CREATE POLICY world_gltf_samplers_metadata_insert_policy ON world_gltf_samplers_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_samplers WHERE world_gltf_samplers.vircadia_uuid = world_gltf_samplers_metadata.sampler_id AND is_admin())
  );

CREATE POLICY world_gltf_samplers_metadata_update_policy ON world_gltf_samplers_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_samplers WHERE world_gltf_samplers.vircadia_uuid = world_gltf_samplers_metadata.sampler_id AND is_admin())
  );

CREATE POLICY world_gltf_samplers_metadata_delete_policy ON world_gltf_samplers_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_samplers WHERE world_gltf_samplers.vircadia_uuid = world_gltf_samplers_metadata.sampler_id AND is_admin())
  );

-- World GLTF Buffers Metadata RLS
CREATE POLICY world_gltf_buffers_metadata_select_policy ON world_gltf_buffers_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_buffers WHERE world_gltf_buffers.vircadia_uuid = world_gltf_buffers_metadata.buffer_id)
  );

CREATE POLICY world_gltf_buffers_metadata_insert_policy ON world_gltf_buffers_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_buffers WHERE world_gltf_buffers.vircadia_uuid = world_gltf_buffers_metadata.buffer_id AND is_admin())
  );

CREATE POLICY world_gltf_buffers_metadata_update_policy ON world_gltf_buffers_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_buffers WHERE world_gltf_buffers.vircadia_uuid = world_gltf_buffers_metadata.buffer_id AND is_admin())
  );

CREATE POLICY world_gltf_buffers_metadata_delete_policy ON world_gltf_buffers_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_buffers WHERE world_gltf_buffers.vircadia_uuid = world_gltf_buffers_metadata.buffer_id AND is_admin())
  );

-- World GLTF Buffer Views Metadata RLS
CREATE POLICY world_gltf_buffer_views_metadata_select_policy ON world_gltf_buffer_views_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_buffer_views WHERE world_gltf_buffer_views.vircadia_uuid = world_gltf_buffer_views_metadata.buffer_view_id)
  );

CREATE POLICY world_gltf_buffer_views_metadata_insert_policy ON world_gltf_buffer_views_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_buffer_views WHERE world_gltf_buffer_views.vircadia_uuid = world_gltf_buffer_views_metadata.buffer_view_id AND is_admin())
  );

CREATE POLICY world_gltf_buffer_views_metadata_update_policy ON world_gltf_buffer_views_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_buffer_views WHERE world_gltf_buffer_views.vircadia_uuid = world_gltf_buffer_views_metadata.buffer_view_id AND is_admin())
  );

CREATE POLICY world_gltf_buffer_views_metadata_delete_policy ON world_gltf_buffer_views_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_buffer_views WHERE world_gltf_buffer_views.vircadia_uuid = world_gltf_buffer_views_metadata.buffer_view_id AND is_admin())
  );

-- World GLTF Accessors Metadata RLS
CREATE POLICY world_gltf_accessors_metadata_select_policy ON world_gltf_accessors_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_accessors WHERE world_gltf_accessors.vircadia_uuid = world_gltf_accessors_metadata.accessor_id)
  );

CREATE POLICY world_gltf_accessors_metadata_insert_policy ON world_gltf_accessors_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_accessors WHERE world_gltf_accessors.vircadia_uuid = world_gltf_accessors_metadata.accessor_id AND is_admin())
  );

CREATE POLICY world_gltf_accessors_metadata_update_policy ON world_gltf_accessors_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_accessors WHERE world_gltf_accessors.vircadia_uuid = world_gltf_accessors_metadata.accessor_id AND is_admin())
  );

CREATE POLICY world_gltf_accessors_metadata_delete_policy ON world_gltf_accessors_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_accessors WHERE world_gltf_accessors.vircadia_uuid = world_gltf_accessors_metadata.accessor_id AND is_admin())
  );

-- World GLTF Animations Metadata RLS
CREATE POLICY world_gltf_animations_metadata_select_policy ON world_gltf_animations_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_animations WHERE world_gltf_animations.vircadia_uuid = world_gltf_animations_metadata.animation_id)
  );

CREATE POLICY world_gltf_animations_metadata_insert_policy ON world_gltf_animations_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_animations WHERE world_gltf_animations.vircadia_uuid = world_gltf_animations_metadata.animation_id AND is_admin())
  );

CREATE POLICY world_gltf_animations_metadata_update_policy ON world_gltf_animations_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_animations WHERE world_gltf_animations.vircadia_uuid = world_gltf_animations_metadata.animation_id AND is_admin())
  );

CREATE POLICY world_gltf_animations_metadata_delete_policy ON world_gltf_animations_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_animations WHERE world_gltf_animations.vircadia_uuid = world_gltf_animations_metadata.animation_id AND is_admin())
  );

-- World GLTF Skins Metadata RLS
CREATE POLICY world_gltf_skins_metadata_select_policy ON world_gltf_skins_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_skins WHERE world_gltf_skins.vircadia_uuid = world_gltf_skins_metadata.skin_id)
  );

CREATE POLICY world_gltf_skins_metadata_insert_policy ON world_gltf_skins_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_skins WHERE world_gltf_skins.vircadia_uuid = world_gltf_skins_metadata.skin_id AND is_admin())
  );

CREATE POLICY world_gltf_skins_metadata_update_policy ON world_gltf_skins_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_skins WHERE world_gltf_skins.vircadia_uuid = world_gltf_skins_metadata.skin_id AND is_admin())
  );

CREATE POLICY world_gltf_skins_metadata_delete_policy ON world_gltf_skins_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_skins WHERE world_gltf_skins.vircadia_uuid = world_gltf_skins_metadata.skin_id AND is_admin())
  );

-- World GLTF Cameras Metadata RLS
CREATE POLICY world_gltf_cameras_metadata_select_policy ON world_gltf_cameras_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM world_gltf_cameras WHERE world_gltf_cameras.vircadia_uuid = world_gltf_cameras_metadata.camera_id)
  );

CREATE POLICY world_gltf_cameras_metadata_insert_policy ON world_gltf_cameras_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM world_gltf_cameras WHERE world_gltf_cameras.vircadia_uuid = world_gltf_cameras_metadata.camera_id AND is_admin())
  );

CREATE POLICY world_gltf_cameras_metadata_update_policy ON world_gltf_cameras_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM world_gltf_cameras WHERE world_gltf_cameras.vircadia_uuid = world_gltf_cameras_metadata.camera_id AND is_admin())
  );

CREATE POLICY world_gltf_cameras_metadata_delete_policy ON world_gltf_cameras_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM world_gltf_cameras WHERE world_gltf_cameras.vircadia_uuid = world_gltf_cameras_metadata.camera_id AND is_admin())
  );