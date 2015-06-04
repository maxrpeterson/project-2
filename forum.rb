require "sinatra/base"
require "sinatra/reloader"
require "pry"
require "pg"
require_relative "./db/data"

module Forum
	class Server < Sinatra::Base
		configure do
			register Sinatra::Reloader
		end

		get '/' do
			erb :index
		end

	end
end