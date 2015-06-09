require_relative "../db/connection"

class User
	def initialize(params={})
		@id = params["id"]
		@fname = params["fname"]
		@lname = params["lname"]
		@gender = params["gender"]
		@email = params["email"]
		@password = params["password"]
		@created = Time.parse(params["created"]) unless params["created"].nil?
	end

	attr_reader :id, :email
	attr_accessor :fname, :lname, :gender
	attr_writer :password

	def self.find_by_id(id)
		result = $db.exec_params("SELECT * FROM users WHERE id=$1", [id]).first
		User.new(result)
	end

	def self.login(email, password)
		user = self.find_by_email(email)
		if !user.nil? && user.password_correct?(password)
			user
		elsif user.nil?
			"User for email address provided doesn't exist"
		elsif !user.password_correct?(password)
			"Incorrect password"
		else
			"Unexpected error"
		end
	end

	def valid?
		if @fname && @email && @password
			@email.delete!(" ")
			@fname.capitalize!
			duplicate = User.find_by_email(@email)
			if duplicate
				"duplicate"
			elsif @email.include?("@")
				true
			else
				"no@"
			end
		else
			false
		end
	end

	def self.find_by_email(email)
		result = $db.exec_params("SELECT * FROM users WHERE email=$1", [email]).first
		User.new(result) unless result.nil?
	end

	def full_name
		if @lname.nil?
			@fname
		else
			"#{@fname} #{@lname}"
		end
	end

	def password_correct?(password)
		@password == password
	end

	def save_new
		id = $db.exec_params("INSERT INTO users (fname, lname, gender, email, password, created) VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP) RETURNING id", [@fname, @lname, @gender, @email, @password]).first
		@id = id["id"]
	end

	def update
		$db.exec_params("UPDATE users SET fname=$1, lname=$2, gender=$3, email=$4 WHERE id=$5", [@fname, @lname, @gender, @email, @id])
	end

	def timestamp
		@created.strftime("Registered %a, %b %e %Y at %l:%M%P")
	end

end