require "helium/dependency/version"

module Helium
  module Dependency
    class Error < StandardError; end

    def self.included(mod)
      mod.extend ClassMethods
    end

    module ClassMethods
      def new(*args, **kwargs, &block)
        instance = allocate

        deps = {}
        dependencies.each do |dep|
          next unless kwargs.key?(dep)
          deps[dep] = kwargs.delete(dep)
        end

        instance.instance_variable_set(:@deps, deps)

        if kwargs.any?
          instance.send :initialize, *args, **kwargs, &block
        else
          instance.send :initialize, *args, &block
        end

        instance
      end

      def dependency(name, public: false, &default_block)
        dependencies << name

        define_method(name) do
          @deps[name] ||= instance_exec(&default_block)
        end

        private(name) unless public
      end

      def dependencies
        @dependencies ||= []
      end
    end

  end
end
