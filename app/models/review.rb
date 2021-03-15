require 'date'

class Review < ActiveRecord::Base
  belongs_to :reservation, optional: true
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence: true
  validate :checkedout?

  def checkedout?
    if self.reservation
      if !(self.reservation.status == "accepted" && self.reservation.checkout.to_s < Date.today.to_s)
        errors.add(:created_at, "Must be after checkout date of previous reservation.")
      end      
    end
  end
end
