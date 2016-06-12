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

class SitUp < Exercise
  def self.model_name
    Exercise.model_name
  end

  def chart_line_style
    'Solid'
  end
end
