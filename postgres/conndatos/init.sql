-- Initialize conndatos database

-- Create user if not exists
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = 'conndatos_user') THEN

      CREATE ROLE conndatos_user LOGIN PASSWORD 'conndatos_password';
   END IF;
END
$$;

-- Create database if not exists
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_database
      WHERE  datname = 'conndatos_db') THEN

      CREATE DATABASE conndatos_db OWNER conndatos_user;
   END IF;
END
$$;
