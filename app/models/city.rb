class City < ActiveRecord::Base

  has_many :companies

  validates :name,    presence: true
  validates :country, presence: true

end
