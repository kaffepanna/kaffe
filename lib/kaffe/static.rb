module Kaffe
  class Static
    def initialize(app=nil, path)
      @app = app
      @files = Rack::File.new(path)
    end

    def call(env)
      res = @files.call(env)
      if res.first == 404 && @app
        res =@app.call(env)
      end

      res
    end
  end
end
