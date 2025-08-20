class Quest < ApplicationRecord
  validates :title, presence: true
end
