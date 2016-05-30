# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string
#  date       :date
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Course < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :date, presence: true

  def as_json(*args)
    super.tap { |hash| hash["title"] = hash.delete "name" }
  end
end
