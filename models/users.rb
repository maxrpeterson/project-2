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

	attr_reader :id, :fname, :lname, :gender, :email
	attr_writer :password

	def self.find_by_id(id)
		result = $db.exec_params("SELECT * FROM users WHERE id=$1", [id]).first
		User.new(result)
	end

	def self.login(email, password)
		user = self.find_by_email(email)
		if !user.nil? && user.password_correct?(password)
			user
		else
			nil
		end
	end

	def self.find_by_email(email)
		result = $db.exec_params("SELECT * FROM users WHERE email=$1", [email]).first
		User.new(result)
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
		$db.exec_params("INSERT INTO users (fname, lname, gender, email, password, created) VALUES ($1, $2, $3, $4, $5, CURRENT_TIMESTAMP)", [@fname, @lname, @gender, @email, @password])
	end

	def update
		$db.exec_params("UPDATE users SET fname=$1, lname=$2, gender=$3, email=$4 WHERE id=$5", [@fname, @lname, @email, @gender, @id])
	end

	def timestamp
		@created.strftime("Registered %a, %b %e %Y at %l:%M%P")
	end

end