module Rack
  class Index_Resolve
    def initialize(app)
      @app = app
    end
    
    def call(env)
      env["PATH_INFO"] = env["PATH_INFO"].gsub(/\/$/, "/index.html")
      (status, headers, body) = @app.call(env)
      [status, headers, body]
    end
  end
end
  
use Rack::Index_Resolve
run Rack::File.new('.')