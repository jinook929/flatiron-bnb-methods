class Neighborhood < ActiveRecord::Base
  belongs_to :city
  
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    result = self.listings.to_a

    self.reservations.each {|reservation|
      if (checkin.to_date < reservation.checkin && checkout.to_date > reservation.checkin) || (checkout.to_date > reservation.checkout && checkin.to_date < reservation.checkout) || (checkin.to_date > reservation.checkin && checkout.to_date < reservation.checkout) || (checkin.to_date < reservation.checkin && checkout.to_date > reservation.checkout)
        result.delete_if {|l| l == reservation.listing}
      end
    }

    result
  end

  def self.highest_ratio_res_to_listings
    neighborhoods = Neighborhood.all
    ratios = Hash.new.tap {|hash|
      neighborhoods.each {|neighborhood|
        if neighborhood.reservations.count.to_f != 0
          hash["#{neighborhood.id}"] = neighborhood.reservations.count.to_f / neighborhood.listings.count.to_f
        else
          hash["#{neighborhood.id}"] = 0
        end
      }
    }
    Neighborhood.find_by_id(ratios.key(ratios.values.max))
  end

  def self.most_res
    reservation_nums = Hash.new.tap {|hash|
      Neighborhood.all.each {|neighborhood|
        hash["#{neighborhood.id}"] = neighborhood.reservations.count
      }
    }
    Neighborhood.find_by_id(reservation_nums.key(reservation_nums.values.max))
  end
end
