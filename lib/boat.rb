class Boat
  attr_reader :type, :price_per_hour, :hours
  def initialize(type, price_per_hour)
    @type = type
    @price_per_hour = price_per_hour
    @hours = 0

  end

  def hours_rented
    @hours
  end

  def add_hour
    @hours += 1
  end 
end
