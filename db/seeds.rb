# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# user = User.find_or_create_by(username: 'someone', email: 'someone@example.com')
# user.update(password: 'password1234', password_confirmation: 'password1234')

user = User.find_by username: 'alice'

create_exercises_p = false
create_weight_entries_p = false
create_courses_p = false
add_push_up_challenge = true

if create_exercises_p
  date = Date.new(2016,1,1)
  push_up_reps = 10
  sit_up_reps = 25

  user.push_ups.destroy_all
  user.sit_ups.destroy_all
  
  (1..20).each do |i|
    user.push_ups.create(repetitions: push_up_reps, date: date)
    user.sit_ups.create(repetitions: sit_up_reps, date: date)

    push_up_reps += (rand(6) - 3)
    sit_up_reps += (rand(6) - 3)
    date = date.tomorrow
  end
end

if create_weight_entries_p
  date = Date.new(2016,1,1)
  weight = 140.0
  (1..10).each do |i|
    user.user_stats.create(date: date, weight: weight)
    date = date + 1.week
    weight += i.even? ? rand : rand * -1
  end
end

if create_courses_p
  c1 = { name: 'Krav Level 1', days: [2, 3, 4, 10, 11, 16, 17, 23, 24, 25] }
  c2 = { name: 'Krav Level 2', days: [6, 13, 20, 27, 10] }
  c3 = { name: 'Sparring', days: [5, 12, 19, 26] }
  c3 = { name: 'JCF', days: [4, 11, 18, 25, 2] }
  c4 = { name: 'Pit', days: [9] }
  c5 = { name: 'Krav Weapons', days: [6, 13, 20, 27]}

  [c1, c2, c3, c4, c5].each do |course|
    course[:days].each do |day|
      date = Date.new(2016, 5, day)
      Course.create(name: course[:name], date: date, user: user)
    end
  end
end

if add_push_up_challenge
  User.all.each do |user|
    user.push_up_challenge_entries.create(week: 1, day: 1, sets: [6, 6, 4, 4, 10], done_at: Date.new(2016, 6, 8), rest: 60)
    user.push_up_challenge_entries.create(week: 1, day: 2, sets: [6, 8, 6, 6, 10], done_at: Date.new(2016, 6, 10), rest: 60)
    user.push_up_challenge_entries.create(week: 1, day: 3, sets: [8, 10, 7, 7, 10], rest: 60)
    user.push_up_challenge_entries.create(week: 2, day: 1, sets: [9, 11, 8, 8, 11], rest: 60)
    user.push_up_challenge_entries.create(week: 2, day: 2, sets: [10, 12, 9, 9, 13], rest: 90)
    user.push_up_challenge_entries.create(week: 2, day: 3, sets: [12, 13, 10, 10, 15], rest: 120)
  end
end
