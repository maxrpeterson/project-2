require_relative "../db/db_connection"

class User
	def initialize(params={})
		@id = params["id"]
		@fname = params["fname"]
		@lname = params["lname"]
		@gender = params["gender"]
		@email = params["email"]
		@password = params["password"]
		@created = params["created"]
	end

	attr_reader :id
	attr_accessor :fname, :lname, :gender, :email
	attr_writer :password

	def self.find_by_id(id)
		result = $db.exec_params("SELECT * FROM users WHERE id=$1", [id]).first
		User.new(result)
	end

	def self.login(email, password)
		user = self.find_by_email(email)
		if !user.nil? && user.password_correct?(password)
			user.id
		else
			nil
		end
	end

	def self.find_by_email(email)
		result = $db.exec_params("SELECT * FROM users WHERE email=$1", [email]).first
		User.new(result)
	end

	def save
	end

	def find_all_posts
		# uhhhh... should this be a "user" method? or a "posts" method?
		# result = $db.exec_params("SELECT * FROM ")
	end

	def password_correct?(password)
		@password == password
	end

end