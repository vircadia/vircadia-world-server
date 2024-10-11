-- Function to check if the current agent is an admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (SELECT role = 'admin' FROM agent_profiles WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Function to check if the current agent is a member
CREATE OR REPLACE FUNCTION is_member()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (SELECT role = 'member' FROM agent_profiles WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Function to check if the current agent is a guest
CREATE OR REPLACE FUNCTION is_guest()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (SELECT role = 'guest' FROM agent_profiles WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Agent Profiles

CREATE OR REPLACE FUNCTION create_agent_profile(
  p_username TEXT,
  p_full_name TEXT,
  p_role agent_role
)
RETURNS UUID AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO agent_profiles (id, username, full_name, role)
  VALUES (auth.uid(), p_username, p_full_name, p_role)
  RETURNING id INTO new_id;
  RETURN new_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

CREATE OR REPLACE FUNCTION update_agent_profile(
  p_username TEXT DEFAULT NULL,
  p_full_name TEXT DEFAULT NULL,
  p_role agent_role DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
  UPDATE agent_profiles
  SET 
    username = COALESCE(p_username, username),
    full_name = COALESCE(p_full_name, full_name),
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
CREATE POLICY agent_profiles_update_policy ON agent_profiles FOR UPDATE USING (auth.uid() = id OR is_admin());
CREATE POLICY agent_profiles_delete_policy ON agent_profiles FOR DELETE USING (is_admin());