-- Initialize lms database

-- Create user if not exists
DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT
      FROM   pg_catalog.pg_roles
      WHERE  rolname = 'lms_user') THEN

      CREATE ROLE lms_user LOGIN PASSWORD 'lms_password';
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
      WHERE  datname = 'lms_db') THEN

      CREATE DATABASE lms_db OWNER lms_user;
   END IF;
END
$$;
