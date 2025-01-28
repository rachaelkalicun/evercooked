class Occasion < ApplicationRecord
  belongs_to :holiday
  has_many :occasions_preparations
  has_many :preparations, through: :occasions_preparations
  accepts_nested_attributes_for :occasions_preparations
end
