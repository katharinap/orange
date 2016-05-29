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

FactoryGirl.define do
  factory :user_stat do
    user
    date '2016-05-28'
    weight '123.4'
  end
end
