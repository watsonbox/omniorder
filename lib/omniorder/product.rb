module Omniorder
  class Product < Struct.new(:code)
    include Productable

    ATTRIBUTES = [
      :code
    ]

    attr_accessor *ATTRIBUTES

    def initialize(attributes = {})
      # Initialize known attributes
      attributes.each do |attribute, value|
        if ATTRIBUTES.include?(attribute.to_sym)
          send("#{attribute}=", value)
        end
      end
    end

    # This implementation assumes the product to exist
    def self.find_by_code(code)
      new(:code => code)
    end
  end
end
