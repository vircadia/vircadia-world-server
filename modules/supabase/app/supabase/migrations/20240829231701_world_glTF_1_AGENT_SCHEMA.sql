--
-- 
-- AGENTS
--
--

CREATE TYPE agent_role AS ENUM ('guest', 'member', 'admin');

-- Create the agent_profiles table
CREATE TABLE public.agent_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE,
    role agent_role NOT NULL DEFAULT 'guest',
    createdat TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updatedat TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create a trigger to automatically update the updatedat column
CREATE OR REPLACE FUNCTION update_agent_profiles_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updatedat = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_agent_profiles_modtime
BEFORE UPDATE ON agent_profiles
FOR EACH ROW EXECUTE FUNCTION update_agent_profiles_modified_column();

-- Create a trigger to automatically create a profile entry when a new user signs up
CREATE OR REPLACE FUNCTION public.handle_new_agent()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.agent_profiles (id, username, role)
  VALUES (new.id, new.raw_user_meta_data->>'username', 'guest');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_agent();

-- Enable RLS for agent_profiles
ALTER TABLE agent_profiles ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for agent_profiles
ALTER PUBLICATION supabase_realtime
ADD TABLE agent_profiles;