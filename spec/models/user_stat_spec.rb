# == Schema Information
#
# Table name: user_stats
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  date       :date
#  weight     :decimal(4, 1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserStat, type: :model do
  describe 'Validations' do
    it 'is not valid without a user' do
      user_stat = build(:user_stat, user: nil)
      expect(user_stat).not_to be_valid
    end

    it 'is not valid without a date' do
      user_stat = build(:user_stat, date: nil)
      expect(user_stat).not_to be_valid
    end

    it 'returns the weight as BigDecimal' do
      user_stat = build(:user_stat, weight: '666.6')
      expect(user_stat).to be_valid
      expect(user_stat.weight).to be_a(BigDecimal)
      expect(user_stat.weight).to eq(666.6)
    end
  end
end
