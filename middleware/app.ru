require_relative './git_status_middleware'

app = ->(env) do
	[200, {"Content-Type" => "text/html"}, ['<html><body><h1>Hey there!</h1></body></html>']]
end

run GitStatusMiddleware.new(app)