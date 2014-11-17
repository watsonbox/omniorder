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
    end
  end
end
