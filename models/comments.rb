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

end
