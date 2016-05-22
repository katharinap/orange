# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  username               :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "Validations" do
    context "on a new user" do
      it "should not be valid without a password" do
        user = build(:user, password: nil, password_confirmation: nil)
        expect(user).not_to be_valid
      end

      it "should be not be valid with a short password" do
        user = build(:user, password: 'short', password_confirmation: 'short')
        expect(user).not_to be_valid
        expect(user.errors.keys).to eq([:password])
        expect(user.errors[:password].first).to match(/too short/)
      end

      it "should not be valid with a confirmation mismatch" do
        user = build(:user, password: 'shortpassword', password_confirmation: 'longpassword')
        expect(user).not_to be_valid
        expect(user.errors.keys).to eq([:password_confirmation])
        expect(user.errors[:password_confirmation].first).to match(/doesn't match/)
      end

      it "should not be valid with a username that could be another user's email address" do
        user = build(:user, username: 'alice@example.com')
        expect(user).not_to be_valid
        expect(user.errors.keys).to eq([:username])
        expect(user.errors[:username].first).to match(/invalid characters/)
      end

      it 'should not be valid with an invalid email' do
        user = build(:user, email: 'aliceexample.com')
        expect(user).not_to be_valid
        expect(user.errors.keys).to eq([:email])
        expect(user.errors[:email].first).to match(/is invalid/)
      end        
    end

    context "on an existing user" do
      it "should be valid with no changes" do
        user = create(:user)
        expect(user).to be_valid
      end

      it "should not be valid with an empty password" do
        user = create(:user)
        user.password = user.password_confirmation = ""
        expect(user).not_to be_valid
        expect(user.errors.keys).to eq([:password])
        expect(user.errors[:password].first).to match(/can't be blank/)
      end

      it "should be valid with a new (valid) password" do
        user = create(:user)
        user.password = user.password_confirmation = "new password"
        expect(user).to be_valid
      end

      it "should be invalid if the new email is already taken" do
        user1 = create(:user, email: 'alice@example.com')
        user2 = create(:user, email: 'bob@example.com')
        expect(user1).to be_valid
        expect(user2).to be_valid
        user2.email = 'alice@example.com'
        expect(user2).not_to be_valid
        expect(user2.errors[:email].first).to match(/has already been taken/)
      end

      it "should be invalid if the new email is already taken" do
        user1 = create(:user, username: 'alice')
        user2 = create(:user, username: 'bob')
        expect(user1).to be_valid
        expect(user2).to be_valid
        user2.username = 'alice'
        expect(user2).not_to be_valid
        expect(user2.errors[:username].first).to match(/has already been taken/)
      end
    end
  end

  describe 'exercises' do
    it 'assigns the push/sit-ups' do
      user = create(:user)
      create_list(:sit_up, 3, user: user)
      create_list(:push_up, 5, user: user)
      expect(user.sit_ups.count).to eq(3)
      expect(user.push_ups.count).to eq(5)
    end
  end
end
