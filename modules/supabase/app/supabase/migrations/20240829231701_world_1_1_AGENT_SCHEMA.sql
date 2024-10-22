--
-- 
-- AGENTS
--
--

-- Create the agent_profiles table
CREATE TABLE public.agent_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE,
    role TEXT NOT NULL,
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_agent();

-- Enable RLS for agent_profiles
ALTER TABLE agent_profiles ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for agent_profiles
ALTER PUBLICATION supabase_realtime
ADD TABLE agent_profiles;

-- Function to check if the current agent has a specific role
CREATE OR REPLACE FUNCTION has_role(p_role TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (SELECT role = p_role FROM agent_profiles WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Agent Profiles

CREATE OR REPLACE FUNCTION create_agent_profile(
  p_username TEXT,
  p_role TEXT
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO agent_profiles (id, username, role)
  VALUES (auth.uid(), p_username, p_role)
  RETURNING id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_agent_profile(
  p_username TEXT DEFAULT NULL,
  p_role TEXT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  UPDATE agent_profiles
  SET 
    username = COALESCE(p_username, username),
    role = COALESCE(p_role, role)
  WHERE id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION delete_agent_profile()
RETURNS VOID AS $$
BEGIN
  DELETE FROM agent_profiles WHERE id = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- RLS for agent_profiles
CREATE POLICY agent_profiles_select_policy ON agent_profiles FOR SELECT USING (true);
CREATE POLICY agent_profiles_insert_policy ON agent_profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY agent_profiles_update_policy ON agent_profiles FOR UPDATE USING (auth.uid() = id OR has_role('admin'));
CREATE POLICY agent_profiles_delete_policy ON agent_profiles FOR DELETE USING (has_role('admin'));

-- 
-- 
-- ROLES
-- 
-- 

