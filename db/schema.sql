-- DROP DATABASE IF EXISTS project_forum;
-- CREATE DATABASE project_forum;
-- \c project_forum
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS likes CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  fname VARCHAR NOT NULL,
  lname VARCHAR,
  gender VARCHAR,
  email VARCHAR NOT NULL,
  password VARCHAR NOT NULL,
  created TIMESTAMP
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  title VARCHAR NOT NULL,
  body TEXT NOT NULL,
  location VARCHAR,
  created TIMESTAMP
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  post_id INTEGER REFERENCES posts(id),
  body VARCHAR NOT NULL,
  created TIMESTAMP
);

CREATE TABLE likes (
  user_id INTEGER REFERENCES users(id),
  post_id INTEGER REFERENCES posts(id)
);