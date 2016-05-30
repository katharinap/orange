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

  KNOWN_NAMES = [
    'Krav Level 1',
    'Krav Level 2',
    'Sparring',
    'Krav Weapons',
    'JCF',
    'Pit',
    'Other'
  ].freeze

  def as_json(*args)
    # we can't call the url attribute just 'url' because fullcalendar
    # automatically visits that url when this attribute is set and we
    # get a cross-site reference error
    super.tap { |hash| hash['title'] = hash.delete 'name' }
         .merge(edit_url: url_helpers.edit_course_path(self))
  end
end
