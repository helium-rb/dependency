require "helium/dependency/version"

module Helium
  module Dependency
    class Error < StandardError; end

    def self.included(mod)
      mod.extend ClassMethods
      mod.prepend Initialization
    end

    module ClassMethods
      def dependency(name, &default_block)
        dependencies << name

        define_method(name) do
          @deps[name] ||= instance_exec(&default_block)
        end

        private name
      end

      def dependencies
        @dependencies ||= []
      end
    end

    module Initialization
      def initialize(*args, **kwargs, &block)
        @deps = {}

        self.class.dependencies.each do |dep|
          next unless kwargs.key?(dep)

          @deps[dep] = kwargs.delete(dep)
        end

        if kwargs.any?
          super *args, **kwargs, &block
        else
          super *args, &block
        end
      end
    end
  end
end
