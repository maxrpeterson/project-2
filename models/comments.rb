require_relative "../db/db_connection"

class Comment
	def initialize(params={})
		@id = params["id"]
		@user_id = params["user_id"]
		@post_id = params["post_id"]
		@body = params["body"]
		@created = params["created"]
		@author = "#{params["fname"]} #{params["lname"]}".chomp
	end

	attr_reader :id, :user_id, :post_id, :body, :author

	def self.get_all_for_post(id)
		comments = $db.exec_params("SELECT comments.*, users.fname, users.lname FROM comments JOIN users ON users.id=comments.user_id WHERE comments.id=$1", [id]).entries
		comments.map do|comment|
			Comment.new(comment)
		end
	end


end
