class Note < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  validates :title, :content, presence: true
end
