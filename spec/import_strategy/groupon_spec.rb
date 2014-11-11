require 'spec_helper'

describe Omniorder::ImportStrategy::Groupon do
  let(:strategy) do
    Omniorder::ImportStrategy::Groupon.new(
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
      Omniorder::ImportStrategy::Groupon.new(:access_token => 'xYRPKcoakMoiRzWgKLV5TqPSdNAaZQT')
    }.to raise_exception "Omniorder::ImportStrategy::Groupon requires a supplier_id"
  end

  it 'raises an exception unless an access_token option is supplied' do
    expect {
      Omniorder::ImportStrategy::Groupon.new(:supplier_id => '1')
    }.to raise_exception "Omniorder::ImportStrategy::Groupon requires an access_token"
  end

  it 'imports orders' do
    orders = []
    strategy.import_orders { |o| orders << o }

    order = orders.first
    expect(order.order_number).to eq("FFB7A681BE")
    expect(order.total_price).to eq(10.99)
    expect(order.date.to_s).to eq("2013-05-16T08:10:00+00:00")
  end
end
