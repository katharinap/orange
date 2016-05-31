require 'rails_helper'

RSpec.describe 'exercises overview', type: :feature, js: true do
  before :each do
    @user = create(:user)
    date = Date.current
    reps = 20
    (1..10).each do |i|
      create(:push_up, user: @user, date: date, repetitions: reps)
      create(:sit_up, user: @user, date: date, repetitions: reps + 10)
      date += 1.day
      reps += i.even? ? rand.to_i : rand.to_i * -1
    end
    login_as(@user, scope: :user)
  end

  it 'does not allow access to another user' do
    real_user = create(:user)
    visit user_exercises_path(real_user)
    expect(page).to have_content "You do not have permission to access #{user_exercises_path(real_user)}."
    expect(current_path).to eq(user_exercises_path(@user))
  end

  it 'allows to create a new push-up entry' do
    visit user_exercises_path(@user)
    click_link 'Add Push-Up'
    within('#exercise-form') do
      fill_in 'Repetitions', with: 17
      fill_in 'Duration', with: 180
      fill_in 'Date', with: '2016-01-01'
      page.execute_script %{ $("a.ui-state-default:contains('28')").trigger("click") }
      click_button 'Save Exercise'
    end
    wait_for_ajax
    expect(@user.push_ups.count).to eq(11)
    expect(@user.push_ups.last.repetitions).to eq(17)
    expect(@user.push_ups.last.duration).to eq(180)
    expect(@user.push_ups.last.date).to eq(Date.new(2016, 1, 28))
    expect(page).to have_content 'Exercise successfully created.'
  end

  it 'allows to create a new sit-up entry' do
    visit user_exercises_path(@user)
    click_link 'Add Sit-Up'
    within('#exercise-form') do
      fill_in 'Repetitions', with: 27
      fill_in 'Duration', with: 150
      fill_in 'Date', with: '2016-02-01'
      page.execute_script %{ $("a.ui-state-default:contains('27')").trigger("click") }
      click_button 'Save Exercise'
    end
    wait_for_ajax
    expect(@user.sit_ups.count).to eq(11)
    expect(@user.sit_ups.last.repetitions).to eq(27)
    expect(@user.sit_ups.last.duration).to eq(150)
    expect(@user.sit_ups.last.date).to eq(Date.new(2016, 2, 27))
    expect(page).to have_content 'Exercise successfully created.'
  end

  it 'allows to edit an existing push-up entry' do
    visit user_exercises_path(@user)
    push_up = @user.push_ups.first
    page.execute_script %{ showModal({ options: { url: '/exercises/#{push_up.id}/edit'}}) }
    within('#exercise-form') do
      fill_in 'Repetitions', with: 27
      fill_in 'Duration', with: 150
      fill_in 'Date', with: '2016-02-01'
      page.execute_script %{ $("a.ui-state-default:contains('27')").trigger("click") }
      click_button 'Save Exercise'
    end
    wait_for_ajax
    expect(@user.push_ups.count).to eq(10)
    push_up = PushUp.find(push_up.id)
    expect(push_up.repetitions).to eq(27)
    expect(push_up.duration).to eq(150)
    expect(push_up.date).to eq(Date.new(2016, 2, 27))
    expect(page).to have_content 'Exercise successfully updated.'
  end

  it 'allows to edit an existing sit-up entry' do
    visit user_exercises_path(@user)
    sit_up = @user.sit_ups.first
    page.execute_script %{ showModal({ options: { url: '/exercises/#{sit_up.id}/edit'}}) }
    within('#exercise-form') do
      fill_in 'Repetitions', with: 27
      fill_in 'Duration', with: 150
      fill_in 'Date', with: '2016-02-01'
      page.execute_script %{ $("a.ui-state-default:contains('27')").trigger("click") }
      click_button 'Save Exercise'
    end
    wait_for_ajax
    expect(@user.sit_ups.count).to eq(10)
    sit_up = SitUp.find(sit_up.id)
    expect(sit_up.repetitions).to eq(27)
    expect(sit_up.duration).to eq(150)
    expect(sit_up.date).to eq(Date.new(2016, 2, 27))
    expect(page).to have_content 'Exercise successfully updated.'
  end

  it 'allows to delete an existing push-up entry' do
    visit user_exercises_path(@user)
    push_up = @user.push_ups.first
    page.execute_script %{ showModal({ options: { url: '/exercises/#{push_up.id}/edit'}}) }
    within('#exercise-form') do
      click_link 'Delete'
    end
    wait_for_ajax
    expect(@user.push_ups.count).to eq(9)
    expect(page).to have_content 'Exercise successfully deleted.'
  end

  it 'allows to delete an existing sit-up entry' do
    visit user_exercises_path(@user)
    sit_up = @user.sit_ups.first
    page.execute_script %{ showModal({ options: { url: '/exercises/#{sit_up.id}/edit'}}) }
    within('#exercise-form') do
      click_link 'Delete'
    end
    wait_for_ajax
    expect(@user.sit_ups.count).to eq(9)
    expect(page).to have_content 'Exercise successfully deleted.'
  end
end
