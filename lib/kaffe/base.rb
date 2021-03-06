require 'rack'
require 'tilt'

module Kaffe
  class Base
    include Kaffe::Error
    include Kaffe::Actions
    include Kaffe::Routes
    include Kaffe::Settings
    include Kaffe::Render

    attr_reader :params, :request, :response, :env

    set :environment, proc { ENV['RACK_ENV'] || :development }

    def initialize(app=nil)
      @app = app
      @templates = {}
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      run! {
        # handle if errors were sent from route
          env['kaffe.error'] = catch(:error) {
            route!
            action!
          }
          error!
      }

      if @app
        @app.call(@response.finish)
      else
        @response.finish
      end
    end

    def run! &block
      begin
        res = catch(:success) { block.call }
        case res
          when String
            @response.body = [res]
          when Array
            @response.status = res[0]
            res[1].each {|h, v| @response.headers[h] = v }
            @response.body = res[2]
          else
            puts "Should not be here"
            @response.status = 500
        end
      rescue # Something gone wrong and havent been handeled.
        puts "WARN: Define your error handlers!!!"
        @response.status = env['kaffe.error'].first
        @response.body = [env['kaffe.error'].last]
      end
    end


    class << self
      def new(*args)
        builder = Rack::Builder.new
        middleware.each {|m, args, block| builder.use(m,*args,&block) }
        builder.run super
        builder.to_app
      end

      def call(env); instance.call(env) end
      def instance; @instance ||= new end
      def middleware; @middleware ||= [] end

      def use(m, *args, &block)
        middleware << [m, args, block]
      end
    end
  end
end


