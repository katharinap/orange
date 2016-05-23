require 'rails_helper'

RSpec.describe 'the signin process', type: :feature do
  before :each do
    @user = create(:user)
    create_list(:push_up, 7, user: @user)
    create_list(:sit_up, 5, user: @user)
    login_as(@user, scope: :user)
  end

  it 'displays the exercises' do
    visit user_path(@user)
    expect(page).to have_table('push-ups-table')
    expect(page.all('table#push-ups-table tbody tr').count).to eq(7)
    expect(page).to have_table('sit-ups-table')
    expect(page.all('table#sit-ups-table tbody tr').count).to eq(5)
  end

  it 'allows to create a new push-up entry' do
    visit user_path(@user)
    within('#push-ups') do
      fill_in 'Repetitions', with: 17
      fill_in 'Duration', with: 180
      fill_in 'Date', with: '2016-01-02'
      click_button 'Create Exercise'
    end
    expect(page.all('table#push-ups-table tbody tr').count).to eq(8)
    expect(@user.push_ups.last.repetitions).to eq(17)
    expect(@user.push_ups.last.duration).to eq(180)
    expect(@user.push_ups.last.date).to eq(Date.new(2016, 1, 2))
  end

  it 'allows to create a new sit-up entry' do
    visit user_path(@user)
    within('#sit-ups') do
      fill_in 'Repetitions', with: 27
      fill_in 'Duration', with: 150
      fill_in 'Date', with: '2016-02-02'
      click_button 'Create Exercise'
    end
    expect(page.all('table#sit-ups-table tbody tr').count).to eq(6)
    expect(@user.sit_ups.last.repetitions).to eq(27)
    expect(@user.sit_ups.last.duration).to eq(150)
    expect(@user.sit_ups.last.date).to eq(Date.new(2016, 2, 2))
  end
end
