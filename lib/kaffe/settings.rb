module Kaffe
  module Settings
    class Config
      def Config.set option, value
        case value
        when Proc
          define_singleton_method(option, value)
        else
          set(option, proc { value })
        end
      end

      def Config.configure &block
        instance_eval &block
      end
    end

    module ClassMethods

      def settings
        @settings ||= if superclass.respond_to? :settings
          Class.new(superclass.settings)
        else
          Kaffe::Settings::Config
        end
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
