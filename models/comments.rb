require_relative "../db/connection"

class Comment
	def initialize(params={})
		@id = params["id"]
		@user_id = params["user_id"]
		@post_id = params["post_id"]
		@body = params["body"]
		@created = Time.parse(params["created"]) unless params["created"].nil?
		@author = "#{params["fname"]} #{params["lname"]}".chomp
	end

	attr_reader :id, :user_id, :post_id, :body, :author

	def self.get_all_for_post(id)
		comments = $db.exec_params("SELECT comments.*, users.fname, users.lname FROM comments JOIN users ON users.id=comments.user_id WHERE comments.post_id=$1 ORDER BY created ASC", [id]).entries
		comments.map do|comment|
			Comment.new(comment)
		end
	end

	def save_new
		$db.exec_params("INSERT INTO comments (user_id, post_id, body, created) VALUES ($1, $2, $3, CURRENT_TIMESTAMP)", [@user_id, @post_id, @body])
	end

	def timestamp
		@created.strftime("%a, %b %e %Y at %l:%M%P")
	end

end
