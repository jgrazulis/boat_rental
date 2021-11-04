class Dock
  attr_reader :name, :max_rental_time, :rental_log, :revenue

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @rental_log = {}
    @revenue = 0
  end

  def rent(boat, renter)
    rental_log[boat] = renter
  end

  def charge(boat) # returns a hash
    renter = rental_log[boat]
    renter_ccn = renter.credit_card_number
    amount_math = boat.price_per_hour * boat.hours_rented
    if boat.hours_rented > max_rental_time
      amount_math = boat.price_per_hour * max_rental_time
    end
    {credit_card_number: renter_ccn, amount: amount_math}

  end

  def return(boat)
    @revenue += charge(boat)[:amount]
    @rental_log.delete(boat)
  end

  def log_hour
    @rental_log.each do |boat, renter|
      boat.add_hour
    end
  end
end
