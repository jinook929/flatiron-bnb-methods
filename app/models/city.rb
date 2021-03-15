require 'date'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, through: :neighborhoods
  has_many :reservations, through: :listings

  validates :name, presence: true

  def city_openings(checkin, checkout)
    result = self.listings.to_a

    if checkin && checkout
      self.reservations.each {|reservation|
        if (checkin.to_date < reservation.checkin && checkout.to_date > reservation.checkin) || (checkout.to_date > reservation.checkout && checkin.to_date < reservation.checkout) || (checkin.to_date > reservation.checkin && checkout.to_date < reservation.checkout) || (checkin.to_date < reservation.checkin && checkout.to_date > reservation.checkout)
          result.delete_if {|l| l == reservation.listing}
        end
      }      
    end

    result
  end

  def self.highest_ratio_res_to_listings
    cities = City.all
    ratios = Hash.new.tap {|hash|
      cities.each {|city|
        if city.reservations.count.to_f != 0
          hash["#{city.id}"] = city.reservations.count.to_f / city.listings.count.to_f
        else
          hash["#{city.id}"] = 0
        end
      }
    }
    City.find_by_id(ratios.key(ratios.values.max))
  end

  def self.most_res
    reservation_nums = Hash.new.tap {|hash|
      City.all.each {|city|
        hash["#{city.id}"] = city.reservations.count
      }
    }
    City.find_by_id(reservation_nums.key(reservation_nums.values.max))
  end
end

