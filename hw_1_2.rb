class Parcel
  attr_accessor :city, :state, :zip, :street, :building, :apt, :value
  
  def initialize(city, state, zip, street, building, apt, value)
    @city, @state, @zip, @street, @building, @apt, @value =
      city, state, zip, street, building, apt, value
  end
  
  def full_address
    "#@building #@street, #@city, #@state #@zip Apt #@apt"
  end
end

class MailFacility
  
  def initialize
    @parcels = []
  end
  
  def posted_parcels_count
    @parcels.count
  end
  
  def post(parcel)
    raise ArgumentError unless parcel.instance_of? Parcel
    @parcels << parcel
  end
  
  def parcels_sent_to(city)
    @parcels.select {|p| p.city == city }
  end
  
  def parcels_with_value_gt(num)
    @parcels.select {|p| p.value > num }
  end
  
  def most_popular_address
    @parcels.inject(Hash.new(0)) {|m,p| m[p.full_address] += 1; m }.sort_by(&:last)[-1].first
  end
end
