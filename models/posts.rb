require_relative "../db/connection"

class Post
	def initialize(params={})
		@id = params["id"]
		@user_id = params["user_id"]
		@title = params["title"]
		@body = params["body"]
		@location = params["location"]
		@likes = params["likes"].to_i || 0
		@created = Time.parse(params["created"]) unless params["created"].nil?
		@author = "#{params["fname"]} #{params["lname"]}".chomp
		@num_comments = params["num_comments"]
	end

	attr_reader :id, :user_id, :title, :body, :location, :likes, :created, :author, :num_comments

	def self.get_all
		# This query is quite long, but it seems to be the only way i could find to
		# get this info from all three tables easily.
		# It returns already sorted by the number of votes
		posts = $db.exec_params("WITH comments_per_post AS (SELECT post_id, count(id) AS num_comments FROM comments GROUP BY post_id), likes_per_post AS (SELECT post_id, count(user_id) AS likes FROM likes GROUP BY post_id) SELECT posts.id, posts.title, posts.created, users.fname, users.lname, comments_per_post.num_comments, likes_per_post.likes FROM posts JOIN users ON posts.user_id=users.id LEFT JOIN comments_per_post ON posts.id=comments_per_post.post_id LEFT JOIN likes_per_post ON posts.id=likes_per_post.post_id ORDER BY likes_per_post.likes DESC NULLS last, posts.created DESC")
		posts.map do |post|
			Post.new(post)
		end
	end

	def self.find_by_id(id)
		result = $db.exec_params("SELECT posts.*, users.fname, users.lname FROM posts JOIN users ON users.id=posts.user_id WHERE posts.id=$1", [id]).first
		Post.new(result) unless result.nil?
	end

	def self.find_by_user_id(id)
		posts = $db.exec_params("SELECT posts.id, posts.title, posts.user_id, posts.created, posts.location, users.fname, users.lname FROM posts JOIN users ON users.id=posts.user_id WHERE posts.user_id=$1", [id]).entries
		posts.map do |post|
			Post.new(post)
		end
	end

	def like
		@num_likes += 1
		self.update
	end

	def get_comments
		# not sure if this should be a posts method or a comments method
	end

	def save_new
		result = $db.exec_params("INSERT INTO posts (user_id, title, body, location, created) VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP) RETURNING id", [@user_id, @title, @body, @location]).first
		result["id"]
	end

	def update
		$db.exec_params("UPDATE posts SET title=$1, body=$2, num_likes=$3 WHERE id=$4", [@title, @body, @num_likes, @id])
		@id
	end

	def timestamp
		@created.strftime("Posted %a, %b %e %Y at %l:%M%P")
	end

end