class Dish < ApplicationRecord
  has_rich_text :body
  has_many :comments
end
