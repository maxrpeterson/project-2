DROP DATABASE IF EXISTS project_forum;
CREATE DATABASE project_forum;
\c project_forum

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  fname VARCHAR NOT NULL,
  lname VARCHAR,
  gender VARCHAR,
  email VARCHAR NOT NULL,
  password VARCHAR NOT NULL
);

CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  title VARCHAR NOT NULL,
  body VARCHAR NOT NULL,
  location VARCHAR,
  num_likes INTEGER
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  post_id INTEGER REFERENCES posts(id),
  body VARCHAR NOT NULL
);