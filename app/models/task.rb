class Task < ApplicationRecord
  enum status: { pending: 0, complete: 1 }
  
  validates :title, :description, presence: true
end