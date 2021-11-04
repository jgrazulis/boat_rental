require './lib/boat'

describe Boat do
  it 'exists' do
    kayak = Boat.new(:kayak, 20)
    expect(kayak).to be_an_instance_of(Boat)
  end


  it 'has attributes' do
    kayak = Boat.new(:kayak, 20)

    expect(kayak.type).to eq(:kayak)
    expect(kayak.price_per_hour).to eq(20)
  end

  it 'can track hours rented' do
    kayak = Boat.new(:kayak, 20)
    kayak.hours_rented

    expect(kayak.hours_rented).to eq(0)
  end

  it 'can add hours to rental and still track hours rented' do
    kayak = Boat.new(:kayak, 20)
    kayak.add_hour
    kayak.add_hour
    kayak.add_hour
    
    expect(kayak.hours_rented).to eq(3)
  end
end
