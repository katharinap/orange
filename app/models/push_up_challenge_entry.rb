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

  scope :done, -> { where.not(done_at: nil) }
  scope :recent, -> { where('done_at > ?', 2.months.ago) }

  def total_reps
    sets.map(&:to_i).reduce(:+)
  end

  def chart_label_name
    'Push Up Challenge'
  end

  def chart_data
    {
      x: milliseconds(done_at),
      y: total_reps
    }
  end

  def chart_line_style
    'Dot'
  end
end
