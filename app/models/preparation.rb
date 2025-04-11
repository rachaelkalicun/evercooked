class Preparation < ApplicationRecord
  belongs_to :dish, optional: false
  belongs_to :user, optional: false

  validates :dish_id, presence: true
  validates :user_id, presence: true

  has_many :occasions_preparations
  has_many :occasions, through: :occasions_preparations
end
