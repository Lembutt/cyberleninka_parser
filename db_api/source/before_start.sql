CREATE DATABASE texts;
CREATE USER bkmanager WITH PASSWORD 'bkmanager_password';
GRANT ALL PRIVILEGES ON DATABASE texts to bkmanager;
-- now switch to bkmanager and connect to 'texts' database
CREATE SCHEMA test;
-- then execute everything from source files