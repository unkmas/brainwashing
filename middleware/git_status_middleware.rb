class GitStatusMiddleware
  DEFAULT_MESSAGE = 'Use git, little bitch'.freeze
  TAG = '<body>'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    code, headers, body = @app.call(env)
    body = inject_current_branch(body) if html?(body)

    [code, headers, body]
  end

  private

  def html?(body)
    body.first.include?(TAG)
  end

  def inject_current_branch(body)
    html = wrap(current_branch || DEFAULT_MESSAGE)

    [
      body.first.rpartition(TAG).tap { |parts| parts.insert(-2, html) }.join
    ]
  end

  def wrap(text)
    "<div class='current-branch'>#{text}</div>"
  end

  def current_branch
    branch = %x{git rev-parse --abbrev-ref HEAD}.strip
    branch.empty? ? nil : branch
  end
end