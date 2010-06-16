module Kaffe
  module Error
    class GenericError < Exception
      def code; @code; end
      def initialize(code, message="There Was An error")
        @code = code
        super(message)
      end
    end
    class ActionNotFound < GenericError
      def initialize(message)
        super(404, message)
      end
    end
    
    class InternalServerError < GenericError
      def initialize(message)
        super(500, message)
      end
    end

    module ClassMethods

      def errors; @errors ||= [] end

      def error(name, &block)
        #TODO: should probably get a better id for this.
        id = :"ERROR #{name}"
        puts "Adding error handler #{id}"
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
    end

    def dispatch_error!
      e = env['kaffe.error'] || [500, "No Error handler"]
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
    end

    def error!
      dispatch_error!
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
