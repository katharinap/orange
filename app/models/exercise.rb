class Exercise < ApplicationRecord
  belongs_to :user

  validates :repetitions, numericality:
                            {
                              only_integer: true,
                              greater_than: 0
                            }

  validates :duration, numericality:
                            {
                              only_integer: true,
                              greater_than_or_equal_to: 0
                            }
end
