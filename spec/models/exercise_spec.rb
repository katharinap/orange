require 'rails_helper'

RSpec.describe Exercise, :type => :model do
  describe 'new' do
    it 'is invalid with a negative duration' do
      sit_up = build(:sit_up, duration: -4)
      expect(sit_up).not_to be_valid
    end

    it 'is invalid with negative repetitions' do
      push_up = build(:push_up, repetitions: -1)
      expect(push_up).not_to be_valid
    end

    it 'is valid with 0 duration' do
      sit_up = build(:sit_up, duration: 0)
      expect(sit_up).to be_valid
    end

    it 'is invalid with 0 repetitions' do
      push_up = build(:push_up, repetitions: 0)
      expect(push_up).not_to be_valid
    end
  end
end
