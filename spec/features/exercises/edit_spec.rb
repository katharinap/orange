require 'rails_helper'

RSpec.describe 'the signin process', type: :feature do
  before :each do
    @user = create(:user)
    create(:push_up, user: @user, repetitions: 10, duration: 120, date: Date.new(2016, 1, 3))
    create(:sit_up, user: @user, repetitions: 15, duration: 100, date: Date.new(2016, 1, 3))
    login_as(@user, scope: :user)
  end

  it 'allows to edit a push up entry' do
    visit edit_exercise_path(@user.push_ups.first)
    fill_in 'Repetitions', with: 13
    fill_in 'Duration', with: 140
    fill_in 'Date', with: '2016-02-02'
    click_button 'Update Exercise'
    # expect(page).to have_content 'Exercise was updated'
    expect(current_path).to eq(user_path(@user))
    exercise = @user.push_ups.first
    expect(exercise.repetitions).to eq(13)
    expect(exercise.duration).to eq(140)
    expect(exercise.date).to eq(Date.new(2016, 2, 2))
  end

  it 'allows to edit a sit up entry' do
    visit edit_exercise_path(@user.sit_ups.first)
    fill_in 'Repetitions', with: 23
    fill_in 'Duration', with: 150
    fill_in 'Date', with: '2016-03-02'
    click_button 'Update Exercise'
    # expect(page).to have_content 'Exercise was updated'
    expect(current_path).to eq(user_path(@user))
    exercise = @user.sit_ups.first
    expect(exercise.repetitions).to eq(23)
    expect(exercise.duration).to eq(150)
    expect(exercise.date).to eq(Date.new(2016, 3, 2))
  end
end
