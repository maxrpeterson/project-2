require_relative "./forum.rb"

use Rack::MethodOverride

run Forum::Server