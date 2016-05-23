# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.find_or_create_by(username: 'test', email: 'test@example.com')
user.update(password: 'password1234', password_confirmation: 'password1234')

date = Date.new(2016,1,1)
push_up_reps = 10
sit_up_reps = 25

(1..20).each do |i|
  user.push_ups.create(repetitions: push_up_reps, date: date)
  user.sit_ups.create(repetitions: sit_up_reps, date: date)

  date = date.tomorrow
  case i.remainder(3)
  when 0
    push_up_reps += 2
    sit_up_reps += 3
  when 1
    push_up_reps += 1
    sit_up_reps -= 1
  when 2
    push_up_reps -= 1
    sit_up_reps += 2
  end    
end
