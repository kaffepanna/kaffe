module Kaffe
  module Settings

    module ClassMethods
      def set option, value
        case value
        when Proc
          define_singleton_method(option, value)
        else
          set(option, proc { value })
        end
      end
    end
    
    def settings; self.class; end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
