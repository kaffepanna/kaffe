module Kaffe
  module Settings

    module ClassMethods
      def set option, value
        case value
        when Proc
          settings.define_singleton_method(option, value)
        else
          set(option, proc { value })
        end
      end

      def settings
        self
      end
    end

    def settings
      self.class.settings
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
