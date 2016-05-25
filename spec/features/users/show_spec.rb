require 'rails_helper'

RSpec.describe 'exercises overview', type: :feature do
  before :each do
    @user = create(:user)
    @push_ups = create_list(:push_up, 7, user: @user)
    @sit_ups = create_list(:sit_up, 5, user: @user)
    login_as(@user, scope: :user)
  end

  it 'displays the exercises' do
    visit user_path(@user)
    (@push_ups + @sit_ups).each do |exercise|
      elm = page.find_by_id("modal-exercise-#{exercise.id}")
      expect(elm).not_to be_nil
    end
  end

  it 'allows to create a new push-up entry' do
    visit user_path(@user)
    within('#new-push-up') do
      fill_in 'Repetitions', with: 17
      fill_in 'Duration', with: 180
      fill_in 'Date', with: '2016-01-02'
      click_button 'Create Exercise'
    end
    expect(@user.push_ups.count).to eq(8)
    expect(@user.push_ups.last.repetitions).to eq(17)
    expect(@user.push_ups.last.duration).to eq(180)
    expect(@user.push_ups.last.date).to eq(Date.new(2016, 1, 2))
  end

  it 'allows to edit an existing push-up entry' do
    visit user_path(@user)
    exercise = @user.push_ups.first
    within("#modal-exercise-#{exercise.id}") do
      fill_in 'Repetitions', with: 17
      fill_in 'Duration', with: 180
      fill_in 'Date', with: '2016-01-02'
      click_button 'Update Exercise'
    end
    expect(@user.push_ups.count).to eq(7)
    exercise = Exercise.find(exercise.id)
    expect(exercise.repetitions).to eq(17)
    expect(exercise.duration).to eq(180)
    expect(exercise.date).to eq(Date.new(2016, 1, 2))
  end

  it 'allows to delete an existing push-up entry' do
    visit user_path(@user)
    exercise = @user.push_ups.last
    within("#modal-exercise-#{exercise.id}") do
      click_link 'Delete'
    end
    expect(@user.push_ups.count).to eq(6)
    expect { Exercise.find(exercise.id) }.to raise_exception(ActiveRecord::RecordNotFound)
  end

  it 'allows to create a new sit-up entry' do
    visit user_path(@user)
    within('#new-sit-up') do
      fill_in 'Repetitions', with: 27
      fill_in 'Duration', with: 150
      fill_in 'Date', with: '2016-02-02'
      click_button 'Create Exercise'
    end
    expect(@user.sit_ups.count).to eq(6)
    expect(@user.sit_ups.last.repetitions).to eq(27)
    expect(@user.sit_ups.last.duration).to eq(150)
    expect(@user.sit_ups.last.date).to eq(Date.new(2016, 2, 2))
  end

  it 'allows to edit an existing push-up entry' do
    visit user_path(@user)
    exercise = @user.sit_ups.first
    within("#modal-exercise-#{exercise.id}") do
      fill_in 'Repetitions', with: 17
      fill_in 'Duration', with: 180
      fill_in 'Date', with: '2016-01-02'
      click_button 'Update Exercise'
    end
    expect(@user.sit_ups.count).to eq(5)
    exercise = Exercise.find(exercise.id)
    expect(exercise.repetitions).to eq(17)
    expect(exercise.duration).to eq(180)
    expect(exercise.date).to eq(Date.new(2016, 1, 2))
  end

  it 'allows to delete an existing sit-up entry' do
    visit user_path(@user)
    exercise = @user.sit_ups.last
    within("#modal-exercise-#{exercise.id}") do
      click_link 'Delete'
    end
    expect(@user.sit_ups.count).to eq(4)
    expect { Exercise.find(exercise.id) }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
