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

  KNOWN = {
    'Krav Level 1' => { short_title: 'KM 1', color: '#75507b' },
    'Krav Level 2' => { short_title: 'KM 2', color: '#3465a4' },
    'Sparring' => { short_title: 'Sparring', color: '#f57900' },
    'Krav Weapons' => { short_title: 'Weapons', color: '#c17d11' },
    'JCF' => { short_title: 'JCF', color: '#73d216' },
    'Pit' => { short_title: 'Pit', color: '#cc0000' },
    'Other' => { short_title: 'Other', color: '#edd400' }
  }.freeze

  def color
    entry = KNOWN[name] || KNOWN['Other']
    entry[:color]
  end

  def as_json(*args)
    # we can't call the url attribute just 'url' because fullcalendar
    # automatically visits that url when this attribute is set and we
    # get a cross-site reference error
    super.tap { |hash| hash['title'] = hash.delete 'name' }
         .merge(edit_url: url_helpers.edit_course_path(self),
                color: color)
  end
end
