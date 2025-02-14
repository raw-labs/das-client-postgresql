-- Create roles
CREATE ROLE admin_role;
CREATE ROLE read_only_role;

-- Grant create database privilege to admin_role
ALTER ROLE admin_role with CREATEDB;

-- Create admin user
CREATE USER fdw_admin WITH PASSWORD '${ADMIN_PASSWORD}';
GRANT admin_role TO fdw_admin;
ALTER USER fdw_admin WITH SUPERUSER;

-- Create read-only user
CREATE USER fdw_read_only WITH PASSWORD '${READONLY_PASSWORD}';
GRANT read_only_role TO fdw_read_only;