module Omniorder
  module Productable
    def <=>(other)
      code <=> other.code
    end
  end
end
