# == Schema Information
#
# Table name: user_stats
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  date       :date
#  weight     :decimal(4, 1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserStat < ApplicationRecord
  belongs_to :user

  scope :recent, -> { where("created_at > ?", 2.months.ago) }
  validates :date, presence: true
end
