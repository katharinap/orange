class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @push_ups = @user.push_ups.order(:date)
    @sit_ups = @user.sit_ups.order(:date)
    @new_push_up = @user.push_ups.build(date: Date.today)
    @new_sit_up = @user.sit_ups.build(date: Date.today)
    @chart = ExerciseChart.new(@sit_ups, @push_ups)
  end
end
