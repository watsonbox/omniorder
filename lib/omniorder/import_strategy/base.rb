module Omniorder
  module ImportStrategy
    class Base
      attr_accessor :import, :options

      def initialize(import, options = {})
        self.import = import
        self.options = options
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
