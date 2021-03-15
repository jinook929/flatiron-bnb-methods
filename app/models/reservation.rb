require 'date'
class Reservation < ActiveRecord::Base
  belongs_to :listing, optional: true
  belongs_to :guest, :class_name => "User"

  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validates :listing_id, presence: true
  # validates :guest_id, presence: true
  validate :same_host_guest?
  validate :available?
  validate :right_dates?

  def duration
    (self.checkout.to_date - self.checkin.to_date).to_i
  end

  def total_price
    self.duration * self.listing.price
  end

  def same_host_guest?
    if self.listing.host == self.guest
      errors.add(:guest_id, "Must be different from host.")
    end
  end

  def available?
    current_reservations = Array.new.tap {|arr|
      self.listing.reservations.each.with_index {|r, i|
        arr[i] = []
        arr[i].push(r.checkin)
        arr[i].push(r.checkout)
      }
    }

    if self.checkin && self.checkout
      if current_reservations.any? {|reservation| (self.checkin.to_date < reservation[0] && self.checkout.to_date > reservation[0]) || (self.checkout.to_date > reservation[1] && self.checkin.to_date < reservation[1]) || (self.checkin.to_date > reservation[0] && self.checkout.to_date < reservation[1]) || (self.checkin.to_date < reservation[0] && self.checkout.to_date > reservation[1])}
        errors.add(:checkin, ": Stay dates must be other than reserved dates.")
        errors.add(:checkout, ": Stay dates must be other than reserved dates.")
      end
    end
  end

  def right_dates?
    if self.checkin && self.checkout
      if self.checkin.to_date >= self.checkout.to_date
        errors.add(:checkin, "Must be before checkout.")
        errors.add(:checkout, "Must be after checkin.")
      end
    end
  end
end
