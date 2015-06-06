require "sinatra/base"
require "sinatra/reloader"
require "pry"
require "redcarpet"
require "rest-client"
require_relative "models/users"
require_relative "models/posts"
require_relative "models/comments"
require_relative "models/likes"

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
				@user_id = session[:user_id]
			end
		end

		# Homepage
		get '/' do
			@posts = Post.get_all
			erb :index
		end

		# sign in/sign up
		post '/users/login' do
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

		delete '/users/login' do
			session.clear
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
			if @user_name
				erb :new_post
			else
				@message = "Please log in!"
				erb :error
			end
		end

		get '/posts/:id' do
			@post = Post.find_by_id(params[:id])
			if @post
				@body = $markdown.render(@post.body)
				@comments = Comment.get_all_for_post(params[:id])
				erb :post
			else
				@message = "Post doesn't exist"
				erb :error
			end
		end

		#make post
		post '/posts' do
			if session[:user_id].nil?
				status 403
				"Unauthorized, please log in."
			else
				ip = (request.ip == "::1") ? "96.232.156.38" : request.ip
				ip_info = JSON.parse(RestClient.get("http://ipinfo.io/#{ip}/json"))
				location = ip_info["city"] + ", " + ip_info["region"]
				post = Post.new "user_id" => session[:user_id], "title" => params[:title], "body" => params[:body], "location" => location
				@post_id = post.save_new
				redirect "/posts/#{@post_id}"
			end
		end

		# Make a comment
		post '/posts/:post_id/comments' do
			comment = Comment.new "user_id" => session[:user_id], "post_id" => params[:post_id], "body" => params[:body]
			comment.save_new
			redirect "/posts/#{params[:post_id]}"
		end

		get '/posts' do
			redirect '/'
		end

		# likes
		post '/posts/:id/likes' do
			post = Post.find_by_id(params[:id])
			post.like
			post.update
			redirect "/posts/#{params[:id]}"
		end

	end # class
end # module