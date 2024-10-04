-- This migration adds application-specific structures and extras to the base glTF schema

-- Add user role enum and column
CREATE TYPE user_role AS ENUM ('guest', 'member', 'admin');

ALTER TABLE public.user_profiles
ADD COLUMN role user_role NOT NULL DEFAULT 'guest';

-- Define JSON schemas for extras

-- Common entity properties schema
CREATE OR REPLACE FUNCTION common_entity_properties_schema() RETURNS json AS $$
BEGIN
  RETURN '{
    "type": "object",
    "properties": {
      "vircadia": {
        "type": "object",
        "properties": {
          "name": { "type": "string" },
          "version": { "type": "string" },
          "createdAt": { "type": "string", "format": "date-time" },
          "updatedAt": { "type": "string", "format": "date-time" },
          "babylonjs": {
            "type": "object",
            "properties": {
              "lod": {
                "type": "object",
                "properties": {
                  "mode": { "type": "string", "enum": ["distance", "size"] },
                  "auto": { "type": "boolean" },
                  "distance": { "type": "number" },
                  "size": { "type": "number" },
                  "hide": { "type": "number" }
                }
              },
              "billboard": {
                "type": "object",
                "properties": {
                  "mode": { "type": "integer", "enum": [0, 1, 2, 4, 7] }
                }
              },
              "lightmap": {
                "type": "object",
                "properties": {
                  "lightmap": { "type": "string" },
                  "level": { "type": "integer" },
                  "color_space": { "type": "string", "enum": ["linear", "sRGB", "gamma"] },
                  "texcoord": { "type": "integer" },
                  "use_as_shadowmap": { "type": "boolean" },
                  "mode": { "type": "string", "enum": ["default", "shadowsOnly", "specular"] }
                }
              },
              "script": {
                "type": "object",
                "properties": {
                  "agent_scripts": {
                    "type": "array",
                    "items": {
                      "type": "object",
                      "properties": {
                        "script": { "type": "string" },
                        "unitTest": { "type": "string" }
                      },
                      "required": ["script", "unitTest"]
                    }
                  },
                  "persistent_scripts": {
                    "type": "array",
                    "items": {
                      "type": "object",
                      "properties": {
                        "runnerAgentId": { "type": "string" },
                        "script": { "type": "string" },
                        "unitTest": { "type": "string" }
                      },
                      "required": ["runnerAgentId", "script", "unitTest"]
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }'::json;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Scene-specific schema
CREATE OR REPLACE FUNCTION scene_specific_schema() RETURNS json AS $$
BEGIN
  RETURN '{
    "type": "object",
    "properties": {
      "vircadia": {
        "type": "object",
        "properties": {
          "babylonjs": {
            "type": "object",
            "properties": {
              "scene": {
                "type": "object",
                "properties": {
                  "clearColor": {
                    "type": "object",
                    "properties": {
                      "r": { "type": "number" },
                      "g": { "type": "number" },
                      "b": { "type": "number" }
                    },
                    "required": ["r", "g", "b"]
                  },
                  "ambientColor": {
                    "type": "object",
                    "properties": {
                      "r": { "type": "number" },
                      "g": { "type": "number" },
                      "b": { "type": "number" }
                    },
                    "required": ["r", "g", "b"]
                  },
                  "gravity": {
                    "type": "object",
                    "properties": {
                      "x": { "type": "number" },
                      "y": { "type": "number" },
                      "z": { "type": "number" }
                    },
                    "required": ["x", "y", "z"]
                  },
                  "activeCamera": { "type": "string" },
                  "collisionsEnabled": { "type": "boolean" },
                  "physicsEnabled": { "type": "boolean" },
                  "physicsGravity": {
                    "type": "object",
                    "properties": {
                      "x": { "type": "number" },
                      "y": { "type": "number" },
                      "z": { "type": "number" }
                    },
                    "required": ["x", "y", "z"]
                  },
                  "physicsEngine": { "type": "string" },
                  "autoAnimate": { "type": "boolean" },
                  "autoAnimateFrom": { "type": "number" },
                  "autoAnimateTo": { "type": "number" },
                  "autoAnimateLoop": { "type": "boolean" },
                  "autoAnimateSpeed": { "type": "number" }
                }
              }
            }
          }
        }
      }
    }
  }'::json;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Apply JSON schemas to the respective tables
ALTER TABLE world_gltf
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT world_gltf_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE scenes
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT scenes_extras_valid
CHECK (extensions.jsonb_matches_schema(
  json_build_object(
    'allOf', 
    json_build_array(
      common_entity_properties_schema(),
      scene_specific_schema()
    )
  ),
  extras
));

-- Apply common entity properties schema to other tables
ALTER TABLE nodes
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT nodes_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE meshes
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT meshes_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE materials
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT materials_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE textures
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT textures_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE images
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT images_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE samplers
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT samplers_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE animations
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT animations_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE skins
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT skins_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE cameras
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT cameras_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE buffers
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT buffers_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE buffer_views
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT buffer_views_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));

ALTER TABLE accessors
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
ADD CONSTRAINT accessors_extras_valid
CHECK (extensions.jsonb_matches_schema(common_entity_properties_schema(), extras));