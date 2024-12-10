class Comment < ApplicationRecord
  belongs_to :dish
  broadcasts_to :dish
end
