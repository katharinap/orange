# == Schema Information
#
# Table name: push_up_challenge_entries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  week       :integer
#  day        :integer
#  sets       :text
#  done_at    :date
#  rest       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :push_up_challenge_entry do
    user nil
    week 1
    day 1
    sets 'MyText'
    rest 1
    done_at Date.new(2016, 1, 1)
  end
end
