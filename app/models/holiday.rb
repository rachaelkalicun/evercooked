class Holiday < ApplicationRecord
  validates :name, presence: true
  has_many :occasions, dependent: :destroy
end
