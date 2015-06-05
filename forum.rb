require "sinatra/base"
require "sinatra/reloader"
require "pry"
require "redcarpet"
require_relative "models/users"
require_relative "models/posts"
require_relative "models/comments"

module Forum
	class Server < Sinatra::Base
		configure do
			register Sinatra::Reloader
      set :sessions, true
		end

		$markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true, safe_links_only: true))

		# Homepage
		get '/' do
			@session_id = session[:user_id] unless session[:user_id].nil?
			@posts = Post.get_all
			erb :index
		end

		# sign in/sign up
		post '/login' do
			result = User.login(params[:email], params[:password])
			if result.nil?
				@message = "Incorrect username or password"
				erb :index
			else
				session[:user_id] = result
				redirect '/'
			end
		end

		delete '/login' do
			session[:user_id] = nil
			redirect '/'
		end

		# USERS
		get '/users/:id' do
			@user = User.find_by_id(params[:id])
			erb :user
		end

		# Create user
		post '/users' do
			binding.pry
			User.new()
		end

		# posts
		get '/posts/new' do
			erb :new_post
		end

		get '/posts/:id' do
			@post = Post.find_by_id(params[:id])

			@body = $markdown.render(@post.body)

			erb :post
		end

		post '/posts' do

			if session[:user_id].nil?
				status 403
				"Unauthorized, please log in."
			else
				#make post
				post = Post.new "user_id" => session[:user_id], "title" => params[:title], "body" => params[:body]
				@post_id = post.save_new
				redirect "/posts/#{@post_id}"
			end
		end

	end
end