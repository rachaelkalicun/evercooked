class Dish < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_rich_text :body
  has_many :preparations
  accepts_nested_attributes_for :preparations
end
