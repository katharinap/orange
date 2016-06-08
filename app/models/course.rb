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

  delegate :url_helpers, to: 'Rails.application.routes'

  COLORS = %w(
    #75507b
    #3465a4
    #f57900
    #c17d11
    #73d216
    #cc0000
    #edd400
  ).freeze

  KNOWN = {
    'Krav Level 1' => { short_title: 'KM 1', color: COLORS[0] },
    'Krav Level 2' => { short_title: 'KM 2', color: COLORS[1] },
    'Sparring' => { short_title: 'Sparring', color: COLORS[2] },
    'Krav Weapons' => { short_title: 'Weapons', color: COLORS[3] },
    'JCF' => { short_title: 'JCF', color: COLORS[4] },
    'Pit' => { short_title: 'Pit', color: COLORS[5] },
    'Other' => { short_title: 'Other', color: COLORS[6] }
  }.freeze

  def color
    entry = KNOWN[name] || KNOWN['Other']
    entry[:color]
  end

  def self.calendar_data(*users)
    courses = []
    if users.size > 1
      users.each_with_index do |user, idx|
        courses += user.courses.map { |c| c.user_calendar_data(idx) }
      end
    else
      courses += users.first.courses.map(&:calendar_data)
    end
    courses
  end

  def calendar_data
    {
      title: name,
      date: date,
      edit_url: url_helpers.edit_course_path(self),
      color: color
    }
  end

  def user_calendar_data(color_idx)
    calendar_data.merge(
      color: COLORS[color_idx],
      tip: user.login
    )
  end
end
