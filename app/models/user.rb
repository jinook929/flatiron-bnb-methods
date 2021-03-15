class User < ActiveRecord::Base
  # as host
  has_many :listings, foreign_key: "host_id"
  has_many :reservations, through: :listings
  has_many :host_reviews, class_name: "Review", through: :reservations#, source: :review
  has_many :guests, class_name: "User", through: :reservations#, source: :guest

  # as guest
  has_many :reviews, foreign_key: "guest_id"
  has_many :trips, class_name: "Reservation", foreign_key: "guest_id"#, source: :reservations
  has_many :trip_listings, through: :trips, source: :listing
  has_many :hosts, class_name: "User", through: :trip_listings#, source: :host
  
  def host?
    if self.listings.empty?
      self.host = false
      self.save
    end
    self.host
  end
end
