\c project_forum
TRUNCATE users CASCADE;
TRUNCATE posts CASCADE;
TRUNCATE comments CASCADE;

INSERT INTO users
  (fname, lname, gender, email, password, created)
VALUES
  ('Max', 'Peterson', 'male', 'petersonmaxr@gmail.com', '12345', CURRENT_TIMESTAMP),
  ('Orin', 'Xie', 'male', 'orin@orin.com', 'password', CURRENT_TIMESTAMP),
  ('Sally', 'Johnson', 'female', 'sally@sally.com', 'password12345', CURRENT_TIMESTAMP),
  ('Steve', null, 'male', 'steve@stevesy.com', 'password', CURRENT_TIMESTAMP);

INSERT INTO posts
  (user_id, title, body, location, created)
VALUES
  (2, 'Hello world!', 'Hey guys, I just signed up, thought I''d say hey!', 'NY', CURRENT_TIMESTAMP),
  (1, 'WHOAAA', 'Oh shit, heyyyy!', 'NY', CURRENT_TIMESTAMP),
  (1, 'I''m back!', 'Hey, how''s it going guys?', 'NY', CURRENT_TIMESTAMP);