require 'rails_helper'

RSpec.describe 'the signin process', type: :feature do
  before :each do
    @user = create(:user, username: 'eve', email: 'eve@example.com', password: 'password')
  end

  it 'signs the user in with her email' do
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Login', with: 'eve@example.com'
      fill_in 'Password', with: 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq(user_exercises_path(@user))
  end

  it 'signs the user in with her username' do
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Login', with: 'eve'
      fill_in 'Password', with: 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq(user_exercises_path(@user))
  end

  it 'does not sign the user in with a wrong password' do
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Login', with: 'eve@example.com'
      fill_in 'Password', with: 'password1234'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Invalid Login or password'
    expect(current_path).to eq(new_user_session_path)
  end

  it 'does not sign the user in with a wrong email' do
    visit new_user_session_path
    within('#new_user') do
      fill_in 'Login', with: 'eve1234@example.com'
      fill_in 'Password', with: 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Invalid Login or password'
    expect(current_path).to eq(new_user_session_path)
  end
end
