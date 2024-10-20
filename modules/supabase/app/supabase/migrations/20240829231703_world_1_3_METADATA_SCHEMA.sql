--
--
-- ENTITIES METADATA
--
--
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
    UNIQUE (entity_id, key)
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
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Create indexes for better query performance using GIN for array columns
CREATE INDEX idx_entities_metadata_lookup ON entities_metadata (entity_id, key, values_text, values_numeric, values_boolean, values_timestamp);

-- Apply the trigger to all metadata tables
CREATE TRIGGER update_entities_metadata_modtime
BEFORE UPDATE ON entities_metadata
FOR EACH ROW EXECUTE FUNCTION update_metadata_modified_column();

-- Enable RLS for all metadata tables
ALTER TABLE entities_metadata ENABLE ROW LEVEL SECURITY;

-- Enable Realtime for all metadata tables
ALTER PUBLICATION supabase_realtime ADD TABLE entities_metadata;

-- Policy for select: Allow all authenticated users to read all entities
CREATE POLICY entities_metadata_select_policy ON entities_metadata
    FOR SELECT USING (auth.role() = 'authenticated');

-- Policy for insert: Allow authenticated users to insert entities
CREATE POLICY entities_metadata_insert_policy ON entities_metadata
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Policy for update: Allow authenticated users to update entities
CREATE POLICY entities_metadata_update_policy ON entities_metadata
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Policy for delete: Allow authenticated users to delete entities
CREATE POLICY entities_metadata_delete_policy ON entities_metadata
    FOR DELETE USING (auth.role() = 'authenticated');
