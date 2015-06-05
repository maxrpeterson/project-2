require_relative "../db/db_connection"

class Post
	def initialize(params={})
		@id = params["id"]
		@user_id = params["user_id"]
		@title = params["title"]
		@body = params["body"]
		@location = params["location"]
		@num_likes = params["num_likes"] || 0
		@created = Time.parse(params["created"]) unless params["created"].nil?
		@author = "#{params["fname"]} #{params["lname"]}".chomp
	end

	attr_reader :id, :user_id, :title, :body, :location, :num_likes, :created, :author

	def self.get_all
		raw_results = $db.exec_params("SELECT posts.*, users.fname, users.lname FROM posts JOIN users ON users.id=posts.user_id")
		posts = raw_results.map do |post|
			Post.new(post)
		end
		posts
	end

	def self.find_by_id(id)
		result = $db.exec_params("SELECT posts.*, users.fname, users.lname FROM posts JOIN users ON users.id=posts.user_id WHERE posts.id=$1", [id]).first
		Post.new(result)
	end

	def like
		@num_likes += 1
	end

	def get_comments
		# not sure if this should be a posts method or a comments method
	end

	def save_new
		result = $db.exec_params("INSERT INTO posts (user_id, title, body, created) VALUES ($1, $2, $3, CURRENT_TIMESTAMP) RETURNING id", [@user_id, @title, @body]).first
		result["id"]
	end

	def update
		# $db.exec_params("")
	end

	def timestamp
		@created.strftime("Posted %a, %b %e %Y at %l:%M%P")
	end

end