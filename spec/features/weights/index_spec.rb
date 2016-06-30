require 'rails_helper'

RSpec.describe 'weight overview', type: :feature, js: true do
  before :each do
    @user = create(:user)
    date = Date.new(2016, 1, 1)
    weight = BigDecimal.new(123)
    (1..10).each do |i|
      create(:user_stat, user: @user, date: date, weight: weight)
      date += 1.week
      weight += i.even? ? rand : rand * -1
    end
    login_as(@user, scope: :user, run_callbacks: false)
  end

  it 'does not allow another user to edit a course' do
    real_user = create(:user)
    user_stat = real_user.user_stats.create(date: Date.new(2016, 1, 1), weight: 100.0)
    visit weights_path
    page.accept_alert 'You do not have permissions to edit this entry' do
      page.execute_script %{ $.ajax({ url: '/weights/#{user_stat.id}/edit' }) }
    end
  end

  it 'displays the weight graph' do
    visit weights_path
    expect(page).not_to have_errors
  end

  it 'allows to create a new weight entry' do
    visit weights_path
    click_link 'Add Entry'
    within('#form') do
      fill_in 'Weight', with: 100
      fill_in 'Date', with: '2016-05-01'
      page.execute_script %{ $("a.ui-state-default:contains('27')").trigger("click") }
      click_button 'Create User stat'
    end

    wait_for_ajax
    user_stats = User.find(@user.id).user_stats
    expect(user_stats.count).to eq(11)
    expect(user_stats.last.weight).to eq(100)
    expect(user_stats.last.date).to eq(Date.new(2016, 5, 27))
    expect(page).to have_content 'Entry successfully created.'
    expect(current_path).to eq(weights_path)
  end

  it 'allows to edit an existing weight entry' do
    visit weights_path
    user_stat = @user.user_stats.first
    page.execute_script %{ showModal({ options: { url: '/weights/#{user_stat.id}/edit'}}) }
    within('#form') do
      fill_in 'Weight', with: 100
      fill_in 'Date', with: '2016-01-01'
      page.execute_script %{ $("a.ui-state-default:contains('28')").trigger("click") }
      click_button 'Update User stat'
    end

    wait_for_ajax
    expect(@user.user_stats.count).to eq(10)
    user_stat = UserStat.find(user_stat.id)
    expect(user_stat.weight).to eq(100)
    expect(user_stat.date).to eq(Date.new(2016, 1, 28))
    expect(page).to have_content 'Entry successfully updated.'
    expect(current_path).to eq(weights_path)
  end

  it 'allows to delete an existing weight entry' do
    visit weights_path
    user_stat = @user.user_stats.first
    page.execute_script %{ showModal({ options: { url: '/weights/#{user_stat.id}/edit'}}) }
    within('#form') do
      click_link 'Delete'
    end
    wait_for_ajax
    expect(@user.user_stats.count).to eq(9)
    expect(page).to have_content 'Entry successfully deleted.'
    expect(current_path).to eq(weights_path)
  end
end
