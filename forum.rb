require "sinatra/base"
require "sinatra/reloader"
require "pry"
require_relative "models/users"
require_relative "models/posts"
require_relative "models/comments"

module Forum
	class Server < Sinatra::Base
		configure do
			register Sinatra::Reloader
		end

		# Homepage
		get '/' do
			erb :index
		end

		# sign in/sign up
		post '/login' do
			result = User.login(params[:email], params[:password])
			binding.pry
			if result.nil?
				@message = "Incorrect username or password"
				erb :index
			else
				session[:user_id] = result
				@session_id = session[:user_id]
				erb :index
			end
		end

		# USERS
		get '/users/:id' do
			@user = User.find_by_id(params[:id])
			erb :user
		end

		post '/users/' do
		end

		# posts
		get '/posts/new' do
			erb :new_post
		end

		post '/posts' do
			if session[:user_id]

				@post = Post.new(params)
			end
			# erb :post
		end

	end
end