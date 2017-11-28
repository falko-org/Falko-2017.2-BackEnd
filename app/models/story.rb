class Story < ApplicationRecord
  include DateValidationHelper
  belongs_to :sprint

  validates :name, presence: true, length: { maximum: 128, minimum: 2 }
  validates :description, length: { maximum: 256 }
  validates :assign, length: { maximum: 32, minimum: 2 }
  validates :pipeline, length: { maximum: 16, minimum: 4 }
  validates :initial_date, presence: true

  validate :is_final_date_valid?
end
