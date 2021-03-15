class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true
  validates :host_id, presence: true

  before_create :hosting

  def hosting
    self.host.host = true
    self.host.save
  end

  def average_review_rating
    ratings = self.reviews.map {|review| review.rating}
    if !ratings.empty?
      ratings.inject(0, :+).to_f / ratings.count.to_f
    else
      "n/a"
    end
  end
end
