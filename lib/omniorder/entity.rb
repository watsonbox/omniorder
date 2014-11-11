module Omniorder
  class Entity
    def self.attributes(*attributes)
      if attributes.empty?
        instance_variable_get('@attributes')
      else
        instance_variable_set('@attributes', attributes)
        attr_accessor *attributes
      end
    end

    def initialize(attributes = {})
      # Initialize known attributes
      attributes.each do |attribute, value|
        if self.class.attributes.include?(attribute.to_sym)
          send("#{attribute}=", value)
        end
      end
    end
  end
end
