require 'spec_helper'

describe Omniorder::Orderable do
  let(:order) { Omniorder::Order.new }

  describe '#add_product_by_code' do
    it 'adds a product to the order when one is found' do
      product = Omniorder::Product.new(:code => 'CODE1')

      expect(Omniorder::Product).to receive(:find_by_code)
        .with('CODE1')
        .and_return(product)

      order.add_product_by_code('CODE1')

      order_product = order.order_products.first
      expect(order_product.quantity).to eq(1)
      expect(order_product.product).to eq(product)
    end

    it 'does nothing when no matching product is found' do
      expect(Omniorder::Product).to receive(:find_by_code)
        .with('CODE1')
        .and_return(nil)

      order.add_product_by_code('CODE1')

      expect(order.order_products.count).to eq(0)
    end
  end
end
