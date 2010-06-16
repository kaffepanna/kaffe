require 'rack'
require 'tilt'
require 'haml'

module Kaffe
  class Base
    include Kaffe::Actions
    include Kaffe::Routes
    include Kaffe::Settings

    attr_reader :params, :request, :response, :env
    def initialize(app=nil)
      @app = app
      @templates = {}
    end

    def render(name)
      #unless template = @templates[name]
        template ||= Tilt.new(name, :ugly => true)
      #end
      template.render(self)
    end

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      run! { 
        route!
        dispatch_action!
      }
    
      @response.finish
    end

    def run! &block
      res = catch(:success) { block.call }
      return unless res
      case res
        when String # Got a action result back
          @response.body = [res]
        when Array  # Got a route result back
          @response.status = res[0]
          res[1].each {|h, v| @response.headers[h] = v }
          @response.body = res[2]
        else
          @response.status = 500
      end

    end

    ## Default settings

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


