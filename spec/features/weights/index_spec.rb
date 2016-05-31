require 'rails_helper'

RSpec.describe 'weight overview', type: :feature, js: true do
  before :each do
    @user = create(:user)
    date = Date.current
    weight = BigDecimal.new(123)
    (1..10).each do |i|
      create(:user_stat, user: @user, date: date, weight: weight)
      date += 1.week
      weight += i.even? ? rand : rand * -1
    end
    login_as(@user, scope: :user, run_callbacks: false)
  end

  it 'does not allow access to another user' do
    real_user = create(:user)
    visit user_weights_path(real_user)
    expect(page).to have_content "You do not have permission to access #{user_weights_path(real_user)}."
    expect(current_path).to eq(user_exercises_path(@user))
  end

  it 'displays the weight graph' do
    visit user_weights_path(@user)
    expect(page).not_to have_errors
  end

  it 'allows to create a new weight entry' do
    visit user_weights_path(@user)
    click_link 'Add Entry'
    within('#weight-form') do
      fill_in 'Weight', with: 100
      fill_in 'Date', with: '2016-01-01'
      page.execute_script %{ $("a.ui-state-default:contains('27')").trigger("click") }
      click_button 'Save User stat'
    end

    wait_for_ajax
    user_stats = User.find(@user.id).user_stats
    expect(user_stats.count).to eq(11)
    expect(user_stats.last.weight).to eq(100)
    expect(user_stats.last.date).to eq(Date.new(2016, 1, 27))
    expect(page).to have_content 'Entry successfully created.'
  end

  it 'allows to edit an existing weight entry' do
    visit user_weights_path(@user)
    user_stat = @user.user_stats.first
    page.execute_script %{ showModal({ options: { url: '/weights/#{user_stat.id}/edit'}}) }
    within('#weight-form') do
      fill_in 'Weight', with: 100
      fill_in 'Date', with: '2016-01-01'
      page.execute_script %{ $("a.ui-state-default:contains('28')").trigger("click") }
      click_button 'Save User stat'
    end

    wait_for_ajax
    expect(@user.user_stats.count).to eq(10)
    user_stat = UserStat.find(user_stat.id)
    expect(user_stat.weight).to eq(100)
    expect(user_stat.date).to eq(Date.new(2016, 1, 28))
    expect(page).to have_content 'Entry successfully updated.'
  end

  it 'allows to delete an existing weight entry' do
    visit user_weights_path(@user)
    user_stat = @user.user_stats.first
    page.execute_script %{ showModal({ options: { url: '/weights/#{user_stat.id}/edit'}}) }
    within('#weight-form') do
      click_link 'Delete'
    end
    wait_for_ajax
    expect(@user.user_stats.count).to eq(9)
    expect(page).to have_content 'Entry successfully deleted.'
  end
end
