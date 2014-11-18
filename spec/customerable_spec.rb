require 'spec_helper'

describe Omniorder::Customerable do
  let(:customer) { Omniorder::Customer.new }

  describe '#first_name' do
    it 'is the first name' do
      customer.name = "Alan Gordon Partridge"
      expect(customer.first_name).to eq("Alan")
    end
  end

  describe '#first_names' do
    it 'is the first names' do
      customer.name = "Alan Gordon Partridge"
      expect(customer.first_names).to eq(["Alan", "Gordon"])
    end
  end

  describe '#last_name' do
    it 'is the last names' do
      customer.name = "Alan Gordon Partridge"
      expect(customer.last_name).to eq("Partridge")
    end
  end

  describe '#full_address' do
    it 'should ignore blank address components' do
      customer.address1 = "29, Sycamore Lane"
      customer.address3 = "Birmingham"
      customer.postcode = "B13 8JU"
      customer.country = "United Kingdom"

      expect(customer.full_address).to eq("29, Sycamore Lane\nBirmingham\nB13 8JU\nUnited Kingdom")
    end
  end
end
