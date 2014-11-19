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
    end
  end
end
