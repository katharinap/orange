# == Schema Information
#
# Table name: exercises
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  type        :string
#  duration    :integer          default(120)
#  repetitions :integer          default(0)
#  date        :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

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

  validates :date, presence: true
end
