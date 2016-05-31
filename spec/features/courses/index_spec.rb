require 'rails_helper'

RSpec.describe 'course overview', type: :feature, js: true do
  before :each do
    @user = create(:user)
    c1 = { name: 'Krav Level 1', days: [2, 3, 4] }
    c2 = { name: 'Krav Level 2', days: [6, 13, 20] }
    c3 = { name: 'Sparring', days: [5, 12, 19] }
    c4 = { name: 'Pit', days: [9, 16, 23] }
    c5 = { name: 'Krav Weapons', days: [6, 13, 20] }
    [c1, c2, c3, c4, c5].each do |course|
      course[:days].each do |day|
        date = Date.new(2016, 5, day)
        Course.create(name: course[:name], date: date, user: @user)
      end
    end
    login_as(@user, scope: :user, run_callbacks: false)
  end

  it 'displays the course graph' do
    visit user_courses_path(@user)
    expect(page).not_to have_errors
  end

  it 'allows to create a new course entry' do
    visit user_courses_path(@user)
    click_link 'Add Krav Level 1'
    within('#course-form') do
      fill_in 'Date', with: '2016-05-10'
      page.execute_script %{ $("a.ui-state-default:contains('10')").trigger("click") }
      click_button 'Save Course'
    end

    wait_for_ajax
    courses = User.find(@user.id).courses
    expect(courses.count).to eq(16)
    expect(courses.last.name).to eq('Krav Level 1')
    expect(courses.last.date).to eq(Date.new(2016, 5, 10))
    expect(page).to have_content 'Course successfully created.'
  end

  it 'allows to edit an existing course entry' do
    visit user_courses_path(@user)
    course = @user.courses.first
    page.execute_script %{ $.ajax({ url: '/courses/#{course.id}/edit' }) }
    within('#course-form') do
      fill_in 'Date', with: '2016-05-10'
      page.execute_script %{ $("a.ui-state-default:contains('11')").trigger("click") }
      click_button 'Save Course'
    end

    wait_for_ajax
    expect(@user.courses.count).to eq(15)
    course = Course.find(course.id)
    expect(course.name).to eq('Krav Level 1')
    expect(course.date).to eq(Date.new(2016, 5, 11))
    expect(page).to have_content 'Course successfully updated.'
  end

  it 'allows to delete an existing course entry' do
    visit user_courses_path(@user)
    course = @user.courses.first
    page.execute_script %{ $.ajax({ url: '/courses/#{course.id}/edit' }) }
    within('#course-form') do
      click_link 'Delete'
    end
    wait_for_ajax
    expect(@user.courses.count).to eq(14)
    expect(page).to have_content 'Course successfully deleted.'
  end
end
