class Dish < ApplicationRecord
  belongs_to :user, optional: false

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :user_id, presence: true

  has_rich_text :body
  has_many :preparations
  accepts_nested_attributes_for :preparations
end
