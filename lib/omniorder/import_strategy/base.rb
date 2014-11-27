module Omniorder
  module ImportStrategy
    class Base
      attr_accessor :import
      attr_writer :options

      class << self
        def options(options = nil)
          if options
            @options = options
          else
            @options || {}
          end
        end

        def clear_options
          @options = nil
        end

        def from_name(name)
          Utils.constantize "Omniorder::ImportStrategy::#{Utils.camelize name}"
        end

        def after_build_order(&block)
          if block_given?
            @after_build_order_block = block
          end
        end

        def after_build_order_block
          @after_build_order_block
        end
      end

      def initialize(import, options = {})
        self.import = import
        self.options = options
      end

      # Combines global and local options
      def options
        self.class.options.merge(@options)
      end

      def before_import

      end

      def after_import

      end

      private

      def customer_country_or_default(country)
        if country.nil? || country.empty?
          Omniorder.default_customer_country
        else
          country
        end
      end

      def after_build_order(order, order_info)
        if self.class.after_build_order_block
          self.class.after_build_order_block.call(order, order_info)
        end

        order
      end
    end
  end
end
