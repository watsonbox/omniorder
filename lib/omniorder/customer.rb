module Omniorder
  class Customer
    include Customerable

    ATTRIBUTES = [
      :username,
      :name,
      :phone,
      :email,
      :address1,
      :address2,
      :address3,
      :address4,
      :postcode,
      :country
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
  end
end
