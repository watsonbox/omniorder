module Omniorder
  class Import
    # Allows the import to control how orders are created
    # e.g. an account could be assigned if system is multi-tennant
    # TODO: Move to Importable?
    def build_order(attributes = {})
      Omniorder.order_type.new({ import: self }.merge(attributes))
    end
  end
end
