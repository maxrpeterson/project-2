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
  (2, 'Hello', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'NY', CURRENT_TIMESTAMP),
  (1, 'WHOAAA', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', 'NY', CURRENT_TIMESTAMP),
  (1, 'yo', 'Hey, how''s it going guys?', 'NY', CURRENT_TIMESTAMP);

INSERT INTO comments
  (user_id, post_id, body, created)
VALUES
  (1, 1, 'FIRST', CURRENT_TIMESTAMP),
  (2, 1, 'DAMNIT, I wanted to be first!', CURRENT_TIMESTAMP),
  (1, 2, 'first!', CURRENT_TIMESTAMP),
  (2, 2, 'AGAIN?!?!', CURRENT_TIMESTAMP),
  (3, 3, 'This is very interesting!', CURRENT_TIMESTAMP);

INSERT INTO likes
  (user_id, post_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 2),
  (2, 3),
  (3, 3),
  (4, 1),
  (4, 3);
