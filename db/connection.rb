require "pg"

configure :development do
	$db = PG.connect(dbname: "project_forum")
end

configure :production do
	require 'uri'
	uri = URI.parse env["DATABASE_URL"]
	$db = PG.connect dbname: uri.path[1..-1], host: uri.host, port: uri.port, user: uri.user, password: uri.password
end