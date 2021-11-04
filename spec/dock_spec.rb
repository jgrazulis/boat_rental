require './lib/dock'
require './lib/renter'
require './lib/boat'

describe Dock do
  it 'exists' do
    dock = Dock.new("The Rowing Dock", 3)

    expect(dock).to be_an_instance_of(Dock)
  end

  it 'has attributes' do
    dock = Dock.new("The Rowing Dock", 3)

    expect(dock.name).to eq("The Rowing Dock")
    expect(dock.max_rental_time).to eq(3)
  end

  it 'can accept renters and create a log' do
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)

    expect(dock.rental_log).to eq({kayak_1 => patrick, kayak_2 => patrick, sup_1 => eugene})
  end

  it 'can charge for rentals' do
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")

    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)
    kayak_1.add_hour
    kayak_1.add_hour

    expect(dock.charge(kayak_1)).to eq({:credit_card_number => "4242424242424242", :amount => 40})
  end

  it 'does not charge past max rental time' do
    dock = Dock.new("The Rowing Dock", 3)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(sup_1, eugene)
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour

    expect(dock.charge(sup_1)).to eq({credit_card_number: "1313131313131313", amount: 45})
  end

  it 'can show revenue' do
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    canoe = Boat.new(:canoe, 25)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    sup_2 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    # Rent Boats out to first Renter
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    # kayak_1 and kayak_2 are rented an additional hour
    dock.log_hour
    dock.rent(canoe, patrick)
    # kayak_1, kayak_2, and canoe are rented an additional hour
    dock.log_hour
    # Revenue should not be generated until boats are returned
    # expect(dock.revenue).to eq(0)
    dock.return(kayak_1)
    dock.return(kayak_2)
    dock.return(canoe)
    expect(dock.revenue).to eq(105)

    dock.rent(sup_1, eugene)
    dock.rent(sup_2, eugene)
    dock.log_hour
    dock.log_hour
    dock.log_hour
    # Any hours rented past the max rental time don't factor into revenuedock.log_hour
    dock.log_hour
    dock.return(sup_1)
    dock.return(sup_2)

    expect(dock.revenue).to eq(195)
  end
end
