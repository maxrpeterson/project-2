require "sinatra/base"
require "redcarpet"
require "rest-client"
require "pg"
require_relative "./models/users"
require_relative "./models/posts"
require_relative "./models/comments"

module Forum

	class Server < Sinatra::Base
		configure do
	    set :sessions, true
	  end

	  configure :production do
	  	require 'uri'
			uri = URI.parse env["DATABASE_URL"]
			$db = PG connect dbname: uri.path[1..-1], host: uri.host, port: uri.port, user: uri.user, password: uri.password
	  end

		configure :development do
			require "sinatra/reloader"
			require "pry"
			register Sinatra::Reloader
	    set :bind, '0.0.0.0'
		end

		$markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true))

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
			result = User.login(params[:email], params[:password])
			if result.class == String
				@message = result
				erb :error
			else
				session[:user_id] = result.id
				session[:user_name] = result.full_name
				redirect back
			end
		end

		delete '/users/login' do
			session.clear
			redirect back
		end

		# USERS
		# edit user profile
		get '/users/edit' do
			@user = User.find_by_id(session[:user_id])
			erb :edit_user
		end

		patch '/users' do
			@user = User.find_by_id(session[:user_id])
			if @user.password_correct?(params[:password]) && @user.fname
				@user.fname = params[:fname]
				@user.lname = params[:lname]
				@user.gender = params[:gender]
				@user.update
				redirect "/users/#{@user.id}"
			elsif @user.fname.nil?
				@message = "Please fill out a first name"
				erb :error
			else
				@message = "Incorrect password"
				erb :error
			end
		end

		get '/users/:id' do
			@user = User.find_by_id(params[:id])
			@posts = Post.find_by_user_id(params[:id])
			erb :user
		end

		# Create user
		post '/users' do
			@user = User.new(params)
			if @user.valid? == "no@"
				@message = "Email address entered didn't have an \"@\" sign, please try again"
				erb :error
			elsif @user.valid? == "duplicate"
				@message = "Email address has already been registered, please try again"
				erb :error
			elsif @user.valid?
				@user.save_new
				session[:user_id] = @user.id
				session[:user_name] = @user.full_name
				redirect "/users/#{@user.id}"
			else
				@message = "Registration details were not valid, please try again"
				erb :error
			end
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
				@message = "Unauthorized, please log in."
				erb :error
			else
				ip = (request.ip == "::1") ? "69.203.152.3" : request.ip
				ip_info = JSON.parse(RestClient.get("http://ipinfo.io/#{ip}/json"))
				location = ip_info["city"] + ", " + ip_info["region"] unless ip_info["bogon"]
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
			post.like(@user_id)
			redirect "/posts/#{params[:id]}"
		end

	end # class
end # module