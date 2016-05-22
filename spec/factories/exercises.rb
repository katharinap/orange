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

FactoryGirl.define do
  factory :sit_up do
    user
    type 'SitUp'
    duration 120
    repetitions 30
  end

  factory :push_up do
    user
    type 'PushUp'
    duration 120
    repetitions 30
  end
end
