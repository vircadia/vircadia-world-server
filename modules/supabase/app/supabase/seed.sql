-- Seed a default admin account

-- Set up default admin credentials
DO $$
DECLARE
    admin_email TEXT := 'admin@vircadia.com';
    admin_password TEXT := 'CHANGE_ME!';
    admin_uuid UUID;
BEGIN
    -- Insert the admin user into auth.users
    INSERT INTO auth.users (
        instance_id,
        id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        recovery_sent_at,
        last_sign_in_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at,
        confirmation_token,
        email_change,
        email_change_token_new,
        recovery_token
    ) VALUES (
        '00000000-0000-0000-0000-000000000000',
        gen_random_uuid(),
        'authenticated',
        'authenticated',
        admin_email,
        crypt(admin_password, gen_salt('bf')),
        NOW(),
        NOW(),
        NOW(),
        '{"provider": "email", "providers": ["email"]}',
        '{"username": "admin", "full_name": "System Administrator"}',
        NOW(),
        NOW(),
        '',
        '',
        '',
        ''
    ) RETURNING id INTO admin_uuid;

    -- Update the user_profiles table to set the admin role
    UPDATE public.agent_profiles
    SET role = 'admin'
    WHERE id = admin_uuid;

    RAISE NOTICE 'Admin account created with UUID: %', admin_uuid;
END $$;

-- Add a note about changing the default admin password
DO $$
BEGIN
    RAISE NOTICE 'IMPORTANT: Remember to change the default admin password after first login!';
END $$;

-- Add the root "seed" entity
INSERT INTO entities (
    general__uuid,
    general__name,
    general__type,
    general__semantic_version,
    general__transform,
    babylonjs__script_persistent_scripts
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'World Seed Entity',
    'MODEL',
    '1.0.0',
    ((0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (1.0, 1.0, 1.0)),
    ARRAY[
        ROW(
            'https://example.com/world-seed-script.js',
            'scripts/world-seed-script.js',
            'https://github.com/your-org/world-scripts'
        )::script_source
    ]
);