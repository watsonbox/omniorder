require 'spec_helper'

describe Omniorder::Orderable do
  let(:product1) { Omniorder::Product.new(:code => 'CODE1') }
  let(:product2) { Omniorder::Product.new(:code => 'CODE2') }
  let(:order) { Omniorder::Order.new }

  before do
    allow(Omniorder::Product).to receive(:find_by_code)
      .with('CODE1')
      .and_return(product1)

    allow(Omniorder::Product).to receive(:find_by_code)
      .with('CODE2')
      .and_return(product2)
  end

  describe '#add_product_by_code' do
    it 'adds a product to the order when one is found' do
      order.add_product_by_code('CODE1')

      order_product = order.order_products.first
      expect(order_product.quantity).to eq(1)
      expect(order_product.product).to eq(product1)
    end

    it 'does nothing when no matching product is found' do
      expect(Omniorder::Product).to receive(:find_by_code)
        .with('CODE1')
        .and_return(nil)

      order.add_product_by_code('CODE1')

      expect(order.order_products.count).to eq(0)
    end
  end

  describe '#product_count' do
    it 'is the sum of all attached product quantities' do
      order.add_product_by_code('CODE1', 10)
      order.add_product_by_code('CODE2', 6)

      expect(order.product_count).to eq(16)
    end
  end

  describe '#product_list' do
    it 'is a human-readable string representing order products' do
      order.add_product_by_code('CODE1', 10)
      order.add_product_by_code('CODE2', 6)

      expect(order.product_list).to eq('10xCODE1/6xCODE2')
    end
  end
end
