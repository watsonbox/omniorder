require 'spec_helper'

describe Omniorder::ImportStrategy::Groupon do
  let(:import) { Omniorder::Import.new }
  let(:strategy) do
    Omniorder::ImportStrategy::Groupon.new(
      import,
      :supplier_id => '1',
      :access_token => 'xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT'
    )
  end

  before do
    stub_request(
      :get,
      strategy.get_orders_url
    ).to_return(
      :body => File.new('spec/assets/imports/groupon/get_orders.json'),
      :status => 200
    )
  end

  it 'raises an exception unless a supplier_id option is supplied' do
    expect {
      Omniorder::ImportStrategy::Groupon.new(import, :access_token => 'xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT')
    }.to raise_exception "Omniorder::ImportStrategy::Groupon requires a supplier_id"
  end

  it 'raises an exception unless an access_token option is supplied' do
    expect {
      Omniorder::ImportStrategy::Groupon.new(import, :supplier_id => '1')
    }.to raise_exception "Omniorder::ImportStrategy::Groupon requires an access_token"
  end

  it 'imports orders with products and a customer' do
    orders = []
    strategy.import_orders { |o| orders << o }

    order = orders.first
    expect(order.order_number).to eq("FFB7A681BE")
    expect(order.total_price).to eq(10.99)
    expect(order.date.to_s).to eq("2013-05-16T08:10:00+00:00")
    expect(order.order_products.count).to eq(1)

    order_product = order.order_products.first
    expect(order_product.quantity).to eq(3)
    expect(order_product.product.code).to eq('03658246')

    customer = order.customer
    expect(customer.name).to eq("SOME BODY HERE")
    expect(customer.phone).to eq("01234 982103")
    expect(customer.address1).to eq("901")
    expect(customer.address2).to eq("GREENFIELDS LANE")
    expect(customer.address3).to eq("BRADFORD")
    expect(customer.address4).to eq("KENT")
    expect(customer.postcode).to eq("SOME ZIP")
    expect(customer.country).to eq("UK")
  end
end
