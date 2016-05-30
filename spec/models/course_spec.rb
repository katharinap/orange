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

require 'rails_helper'

RSpec.describe Course, :type => :model do
  describe 'validations' do
    it 'is not valid without a date' do
      course = build(:course, date: nil)
      expect(course).not_to be_valid
      expect(course.errors.keys).to eq([:date])
      expect(course.errors[:date].first).to match(/can't be blank/)
    end

    it 'is not valid without a name' do
      course = build(:course, name: nil)
      expect(course).not_to be_valid
      expect(course.errors.keys).to eq([:name])
      expect(course.errors[:name].first).to match(/can't be blank/)
    end

    it 'is not valid without a user' do
      course = build(:course, user: nil)
      expect(course).not_to be_valid
      expect(course.errors.keys).to eq([:user])
      expect(course.errors[:user].first).to match(/must exist/)
    end

    it 'is valid with date, name and user' do
      course = build(:course)
      expect(course).to be_valid
    end
  end
end
