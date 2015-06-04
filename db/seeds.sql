\c project_forum
TRUNCATE users CASCADE;

INSERT INTO users
  (fname, lname, gender, email, password)
VALUES
  ('Max', 'Peterson', 'male', 'petersonmaxr@gmail.com', '12345'),
  ('Orin', 'Xie', 'male', 'orin@orin.com', 'password'),
  ('Sally', 'Johnson', 'female', 'sally@sally.com', 'password12345'),
  ('Steve', null, 'male', 'steve@stevesy.com', 'password');