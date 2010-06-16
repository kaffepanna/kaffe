module Kaffe
  module Error
    module ClassMethods

      def errors; @errors ||= [] end

      def error(name, &block)
        id = :"ERROR #{name}"
        define_method(id, &block)
        case name
        when Range 
          errors << [name, id]
        when Fixnum
          errors << [name, id]
        else
          raise ArgumentError, "error must be a fixnum or range"
        end
      end
    end

    def register_error(code, message)
      env['kaffe.error'] = [code, message]
      throw :error, env['kaffe.error']
    end

    def dispatch_error!
      e = env['kaffe.error'] || [500, "Unknown Server Error"]
      code = e.first
      block=nil
      self.class.errors.each do |name, id|
        case name
        when Fixnum
          block = method(id) if name == code
          break
        when Range
          block = method(id) if name.include? code
          break
        end
      end
      if(block)
        @response.status = code
        throw:success, if block.arity != 0
          block.call(*e)
        else
          block.call
        end
      end
      throw :error, e
    end

    def error!
      dispatch_error!
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
