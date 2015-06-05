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

		before do
			if session[:user_name]
				@user_name = session[:user_name]
			else
				@user_name = nil
			end
		end

		# Homepage
		get '/' do
			@posts = Post.get_all
			erb :index
		end

		# sign in/sign up
		post '/login' do
			user = User.login(params[:email], params[:password])
			if user.nil?
				@message = "Incorrect username or password"
				@posts = Post.get_all
				erb :index
			else
				session[:user_id] = user.id
				session[:user_name] = user.full_name
				redirect '/'
			end
		end

		delete '/login' do
			session[:user_id] = nil
			@message = "Logged Out!"
			redirect '/'
		end

		# USERS
		get '/users/:id' do
			@user = User.find_by_id(params[:id])
			@posts = Post.find_by_user_id(params[:id])
			erb :user
		end

		# Create user
		post '/users' do
			user = User.new(params)
			user.save_new
		end

		# posts
		get '/posts/new' do
				erb :new_post
		end

		get '/posts/:id' do
			@post = Post.find_by_id(params[:id])
			@body = $markdown.render(@post.body)
			@comments = []
			erb :post
		end

		#make post
		post '/posts' do
			if session[:user_id].nil?
				status 403
				"Unauthorized, please log in."
			else
				post = Post.new "user_id" => session[:user_id], "title" => params[:title], "body" => params[:body]
				@post_id = post.save_new
				redirect "/posts/#{@post_id}"
			end
		end

		post '/posts/:post_id/comments' do

		end

	end

end