-- World GLTF Metadata

CREATE OR REPLACE FUNCTION create_world_gltf_metadata(
  p_world_gltf_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create world_gltf metadata entries';
  END IF;

  INSERT INTO world_gltf_metadata (world_gltf_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_world_gltf_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_world_gltf_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update world_gltf metadata entries';
  END IF;

  UPDATE world_gltf_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_world_gltf_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete world_gltf metadata entries';
  END IF;

  DELETE FROM world_gltf_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Scenes Metadata

CREATE OR REPLACE FUNCTION create_scene_metadata(
  p_scene_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create scene metadata entries';
  END IF;

  INSERT INTO scenes_metadata (scene_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_scene_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_scene_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update scene metadata entries';
  END IF;

  UPDATE scenes_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_scene_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete scene metadata entries';
  END IF;

  DELETE FROM scenes_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Nodes Metadata

CREATE OR REPLACE FUNCTION create_node_metadata(
  p_node_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create node metadata entries';
  END IF;

  INSERT INTO nodes_metadata (node_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_node_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_node_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update node metadata entries';
  END IF;

  UPDATE nodes_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_node_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete node metadata entries';
  END IF;

  DELETE FROM nodes_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Meshes Metadata

CREATE OR REPLACE FUNCTION create_mesh_metadata(
  p_mesh_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create mesh metadata entries';
  END IF;

  INSERT INTO meshes_metadata (mesh_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_mesh_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_mesh_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update mesh metadata entries';
  END IF;

  UPDATE meshes_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_mesh_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete mesh metadata entries';
  END IF;

  DELETE FROM meshes_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Materials Metadata

CREATE OR REPLACE FUNCTION create_material_metadata(
  p_material_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create material metadata entries';
  END IF;

  INSERT INTO materials_metadata (material_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_material_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_material_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update material metadata entries';
  END IF;

  UPDATE materials_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_material_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete material metadata entries';
  END IF;

  DELETE FROM materials_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Textures Metadata

CREATE OR REPLACE FUNCTION create_texture_metadata(
  p_texture_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create texture metadata entries';
  END IF;

  INSERT INTO textures_metadata (texture_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_texture_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_texture_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update texture metadata entries';
  END IF;

  UPDATE textures_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_texture_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete texture metadata entries';
  END IF;

  DELETE FROM textures_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Images Metadata

CREATE OR REPLACE FUNCTION create_image_metadata(
  p_image_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create image metadata entries';
  END IF;

  INSERT INTO images_metadata (image_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_image_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_image_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update image metadata entries';
  END IF;

  UPDATE images_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_image_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete image metadata entries';
  END IF;

  DELETE FROM images_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Samplers Metadata

CREATE OR REPLACE FUNCTION create_sampler_metadata(
  p_sampler_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create sampler metadata entries';
  END IF;

  INSERT INTO samplers_metadata (sampler_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_sampler_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_sampler_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update sampler metadata entries';
  END IF;

  UPDATE samplers_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_sampler_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete sampler metadata entries';
  END IF;

  DELETE FROM samplers_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Buffers Metadata

CREATE OR REPLACE FUNCTION create_buffer_metadata(
  p_buffer_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create buffer metadata entries';
  END IF;

  INSERT INTO buffers_metadata (buffer_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_buffer_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_buffer_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update buffer metadata entries';
  END IF;

  UPDATE buffers_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_buffer_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete buffer metadata entries';
  END IF;

  DELETE FROM buffers_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Buffer Views Metadata

CREATE OR REPLACE FUNCTION create_buffer_view_metadata(
  p_buffer_view_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create buffer view metadata entries';
  END IF;

  INSERT INTO buffer_views_metadata (buffer_view_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_buffer_view_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_buffer_view_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update buffer view metadata entries';
  END IF;

  UPDATE buffer_views_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_buffer_view_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete buffer view metadata entries';
  END IF;

  DELETE FROM buffer_views_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Accessors Metadata

CREATE OR REPLACE FUNCTION create_accessor_metadata(
  p_accessor_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create accessor metadata entries';
  END IF;

  INSERT INTO accessors_metadata (accessor_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_accessor_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_accessor_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update accessor metadata entries';
  END IF;

  UPDATE accessors_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_accessor_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete accessor metadata entries';
  END IF;

  DELETE FROM accessors_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Animations Metadata

CREATE OR REPLACE FUNCTION create_animation_metadata(
  p_animation_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create animation metadata entries';
  END IF;

  INSERT INTO animations_metadata (animation_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_animation_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_animation_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update animation metadata entries';
  END IF;

  UPDATE animations_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_animation_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete animation metadata entries';
  END IF;

  DELETE FROM animations_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Skins Metadata

CREATE OR REPLACE FUNCTION create_skin_metadata(
  p_skin_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create skin metadata entries';
  END IF;

  INSERT INTO skins_metadata (skin_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_skin_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_skin_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update skin metadata entries';
  END IF;

  UPDATE skins_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_skin_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete skin metadata entries';
  END IF;

  DELETE FROM skins_metadata WHERE metadata_id = p_metadata_id;
  END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Cameras Metadata

CREATE OR REPLACE FUNCTION create_camera_metadata(
  p_camera_id UUID,
  p_key TEXT,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can create camera metadata entries';
  END IF;

  INSERT INTO cameras_metadata (camera_id, key, value_text, value_numeric, value_boolean, value_timestamp)
  VALUES (p_camera_id, p_key, p_value_text, p_value_numeric, p_value_boolean, p_value_timestamp)
  RETURNING metadata_id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION update_camera_metadata(
  p_metadata_id UUID,
  p_key TEXT DEFAULT NULL,
  p_value_text TEXT DEFAULT NULL,
  p_value_numeric NUMERIC DEFAULT NULL,
  p_value_boolean BOOLEAN DEFAULT NULL,
  p_value_timestamp TIMESTAMPTZ DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can update camera metadata entries';
  END IF;

  UPDATE cameras_metadata
  SET 
    key = COALESCE(p_key, key),
    value_text = COALESCE(p_value_text, value_text),
    value_numeric = COALESCE(p_value_numeric, value_numeric),
    value_boolean = COALESCE(p_value_boolean, value_boolean),
    value_timestamp = COALESCE(p_value_timestamp, value_timestamp)
  WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION delete_camera_metadata(p_metadata_id UUID)
RETURNS VOID AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Only admins can delete camera metadata entries';
  END IF;

  DELETE FROM cameras_metadata WHERE metadata_id = p_metadata_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

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

-- Scenes Metadata RLS
CREATE POLICY scenes_metadata_select_policy ON scenes_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM scenes WHERE scenes.vircadia_uuid = scenes_metadata.scene_id)
  );

CREATE POLICY scenes_metadata_insert_policy ON scenes_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM scenes WHERE scenes.vircadia_uuid = scenes_metadata.scene_id AND is_admin())
  );

CREATE POLICY scenes_metadata_update_policy ON scenes_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM scenes WHERE scenes.vircadia_uuid = scenes_metadata.scene_id AND is_admin())
  );

CREATE POLICY scenes_metadata_delete_policy ON scenes_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM scenes WHERE scenes.vircadia_uuid = scenes_metadata.scene_id AND is_admin())
  );

-- Nodes Metadata RLS
CREATE POLICY nodes_metadata_select_policy ON nodes_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM nodes WHERE nodes.vircadia_uuid = nodes_metadata.node_id)
  );

CREATE POLICY nodes_metadata_insert_policy ON nodes_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM nodes WHERE nodes.vircadia_uuid = nodes_metadata.node_id AND is_admin())
  );

CREATE POLICY nodes_metadata_update_policy ON nodes_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM nodes WHERE nodes.vircadia_uuid = nodes_metadata.node_id AND is_admin())
  );

CREATE POLICY nodes_metadata_delete_policy ON nodes_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM nodes WHERE nodes.vircadia_uuid = nodes_metadata.node_id AND is_admin())
  );

-- Meshes Metadata RLS
CREATE POLICY meshes_metadata_select_policy ON meshes_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM meshes WHERE meshes.vircadia_uuid = meshes_metadata.mesh_id)
  );

CREATE POLICY meshes_metadata_insert_policy ON meshes_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM meshes WHERE meshes.vircadia_uuid = meshes_metadata.mesh_id AND is_admin())
  );

CREATE POLICY meshes_metadata_update_policy ON meshes_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM meshes WHERE meshes.vircadia_uuid = meshes_metadata.mesh_id AND is_admin())
  );

CREATE POLICY meshes_metadata_delete_policy ON meshes_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM meshes WHERE meshes.vircadia_uuid = meshes_metadata.mesh_id AND is_admin())
  );

-- Materials Metadata RLS
CREATE POLICY materials_metadata_select_policy ON materials_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM materials WHERE materials.vircadia_uuid = materials_metadata.material_id)
  );

CREATE POLICY materials_metadata_insert_policy ON materials_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM materials WHERE materials.vircadia_uuid = materials_metadata.material_id AND is_admin())
  );

CREATE POLICY materials_metadata_update_policy ON materials_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM materials WHERE materials.vircadia_uuid = materials_metadata.material_id AND is_admin())
  );

CREATE POLICY materials_metadata_delete_policy ON materials_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM materials WHERE materials.vircadia_uuid = materials_metadata.material_id AND is_admin())
  );

-- Textures Metadata RLS
CREATE POLICY textures_metadata_select_policy ON textures_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM textures WHERE textures.vircadia_uuid = textures_metadata.texture_id)
  );

CREATE POLICY textures_metadata_insert_policy ON textures_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM textures WHERE textures.vircadia_uuid = textures_metadata.texture_id AND is_admin())
  );

CREATE POLICY textures_metadata_update_policy ON textures_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM textures WHERE textures.vircadia_uuid = textures_metadata.texture_id AND is_admin())
  );

CREATE POLICY textures_metadata_delete_policy ON textures_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM textures WHERE textures.vircadia_uuid = textures_metadata.texture_id AND is_admin())
  );

-- Images Metadata RLS
CREATE POLICY images_metadata_select_policy ON images_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM images WHERE images.vircadia_uuid = images_metadata.image_id)
  );

CREATE POLICY images_metadata_insert_policy ON images_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM images WHERE images.vircadia_uuid = images_metadata.image_id AND is_admin())
  );

CREATE POLICY images_metadata_update_policy ON images_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM images WHERE images.vircadia_uuid = images_metadata.image_id AND is_admin())
  );

CREATE POLICY images_metadata_delete_policy ON images_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM images WHERE images.vircadia_uuid = images_metadata.image_id AND is_admin())
  );

-- Samplers Metadata RLS
CREATE POLICY samplers_metadata_select_policy ON samplers_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM samplers WHERE samplers.vircadia_uuid = samplers_metadata.sampler_id)
  );

CREATE POLICY samplers_metadata_insert_policy ON samplers_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM samplers WHERE samplers.vircadia_uuid = samplers_metadata.sampler_id AND is_admin())
  );

CREATE POLICY samplers_metadata_update_policy ON samplers_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM samplers WHERE samplers.vircadia_uuid = samplers_metadata.sampler_id AND is_admin())
  );

CREATE POLICY samplers_metadata_delete_policy ON samplers_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM samplers WHERE samplers.vircadia_uuid = samplers_metadata.sampler_id AND is_admin())
  );

-- Buffers Metadata RLS
CREATE POLICY buffers_metadata_select_policy ON buffers_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM buffers WHERE buffers.vircadia_uuid = buffers_metadata.buffer_id)
  );

CREATE POLICY buffers_metadata_insert_policy ON buffers_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM buffers WHERE buffers.vircadia_uuid = buffers_metadata.buffer_id AND is_admin())
  );

CREATE POLICY buffers_metadata_update_policy ON buffers_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM buffers WHERE buffers.vircadia_uuid = buffers_metadata.buffer_id AND is_admin())
  );

CREATE POLICY buffers_metadata_delete_policy ON buffers_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM buffers WHERE buffers.vircadia_uuid = buffers_metadata.buffer_id AND is_admin())
  );

-- Buffer Views Metadata RLS
CREATE POLICY buffer_views_metadata_select_policy ON buffer_views_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM buffer_views WHERE buffer_views.vircadia_uuid = buffer_views_metadata.buffer_view_id)
  );

CREATE POLICY buffer_views_metadata_insert_policy ON buffer_views_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM buffer_views WHERE buffer_views.vircadia_uuid = buffer_views_metadata.buffer_view_id AND is_admin())
  );

CREATE POLICY buffer_views_metadata_update_policy ON buffer_views_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM buffer_views WHERE buffer_views.vircadia_uuid = buffer_views_metadata.buffer_view_id AND is_admin())
  );

CREATE POLICY buffer_views_metadata_delete_policy ON buffer_views_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM buffer_views WHERE buffer_views.vircadia_uuid = buffer_views_metadata.buffer_view_id AND is_admin())
  );

-- Accessors Metadata RLS
CREATE POLICY accessors_metadata_select_policy ON accessors_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM accessors WHERE accessors.vircadia_uuid = accessors_metadata.accessor_id)
  );

CREATE POLICY accessors_metadata_insert_policy ON accessors_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM accessors WHERE accessors.vircadia_uuid = accessors_metadata.accessor_id AND is_admin())
  );

CREATE POLICY accessors_metadata_update_policy ON accessors_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM accessors WHERE accessors.vircadia_uuid = accessors_metadata.accessor_id AND is_admin())
  );

CREATE POLICY accessors_metadata_delete_policy ON accessors_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM accessors WHERE accessors.vircadia_uuid = accessors_metadata.accessor_id AND is_admin())
  );

-- Animations Metadata RLS
CREATE POLICY animations_metadata_select_policy ON animations_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM animations WHERE animations.vircadia_uuid = animations_metadata.animation_id)
  );

CREATE POLICY animations_metadata_insert_policy ON animations_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM animations WHERE animations.vircadia_uuid = animations_metadata.animation_id AND is_admin())
  );

CREATE POLICY animations_metadata_update_policy ON animations_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM animations WHERE animations.vircadia_uuid = animations_metadata.animation_id AND is_admin())
  );

CREATE POLICY animations_metadata_delete_policy ON animations_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM animations WHERE animations.vircadia_uuid = animations_metadata.animation_id AND is_admin())
  );

-- Skins Metadata RLS
CREATE POLICY skins_metadata_select_policy ON skins_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM skins WHERE skins.vircadia_uuid = skins_metadata.skin_id)
  );

CREATE POLICY skins_metadata_insert_policy ON skins_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM skins WHERE skins.vircadia_uuid = skins_metadata.skin_id AND is_admin())
  );

CREATE POLICY skins_metadata_update_policy ON skins_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM skins WHERE skins.vircadia_uuid = skins_metadata.skin_id AND is_admin())
  );

CREATE POLICY skins_metadata_delete_policy ON skins_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM skins WHERE skins.vircadia_uuid = skins_metadata.skin_id AND is_admin())
  );

-- Cameras Metadata RLS
CREATE POLICY cameras_metadata_select_policy ON cameras_metadata 
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM cameras WHERE cameras.vircadia_uuid = cameras_metadata.camera_id)
  );

CREATE POLICY cameras_metadata_insert_policy ON cameras_metadata 
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM cameras WHERE cameras.vircadia_uuid = cameras_metadata.camera_id AND is_admin())
  );

CREATE POLICY cameras_metadata_update_policy ON cameras_metadata 
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM cameras WHERE cameras.vircadia_uuid = cameras_metadata.camera_id AND is_admin())
  );

CREATE POLICY cameras_metadata_delete_policy ON cameras_metadata 
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM cameras WHERE cameras.vircadia_uuid = cameras_metadata.camera_id AND is_admin())
  );