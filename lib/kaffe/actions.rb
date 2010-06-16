module Kaffe
  class ActionNotFound < Exception; end

  module Actions
    module ClassMethods
      attr_accessor :actions
      def actions; @actions ||= Hash.new {|hash, key| hash[key] = []} end

      def call(env); instance.call(env) end
      def get(path, &block); action('GET', path, &block) end
      def post(path, &block); action('POST', path, &block) end
      
      def action(method, path, &block)
        id = :"#{method} #{path}" 
        define_method(id, &block)
        expr, keys = compile!(path)
        actions[method] << [expr, keys, id]
      end

      def compile!(path)
        keys = []
        if path.is_a? Regexp
          keys = 'splat'
          pattern = path
        elsif path.is_a? String
          pattern =path.gsub(/(:\w+)/) do |match|
            keys << $1[1..-1]
            "([^/?&#]+)"
          end
        end
        return [/^#{pattern}$/, keys]
      end
    end

    def action!
      routes = self.class.actions[@request.request_method]
      path   = @request.path_info
      routes.each do |expr, keys, id|
        if path.match(expr)
          values = $~.captures.to_a
          if keys == "splat"
            hash = {'splat' => values }
          else
            hash = Hash[keys.zip(values)]
          end
          @request.params.merge! hash
          m = method(id)
          throw :success, if m.arity != 0
            m.call(*values)
          else
            m.call
          end
        end
      end
      raise ActionNotFound, "Could not find matching action for #{path}"
    end

    def dispatch_action!
      begin
        action!
      rescue ActionNotFound => error
        @response.status = 404
        @response.body = ["Not Found #{error}"]
      rescue Exception => error
        @response.status = 500
        @response.body = [error.to_s]
      ensure
        # TODO: after filter!
      end
      nil
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
