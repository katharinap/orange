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

class PushUpChallengeEntry < ApplicationRecord
  belongs_to :user
  serialize :sets

  def total_reps
    sets.map(&:to_i).reduce(:+)
  end
end
