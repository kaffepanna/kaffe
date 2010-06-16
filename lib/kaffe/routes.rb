module Kaffe
  module Routes
    module ClassMethods
      attr_accessor :routes
      def routes; @routes ||= Array.new end

      def route(path, app)
        routes.push [path, app]
      end
    end
  
    def route!
      
      puts "DEBUG: route! in #{self.class.name}"
      path = env["PATH_INFO"].to_s

      self.class.routes.each do |exp, app|
        if path.match exp 
          match = $~.to_s
          throw :success, app.call(env.merge(
            "PATH_INFO"   => path[match.size..-1],
            "SCRIPT_NAME" => match))         
        end
      end
      nil
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
