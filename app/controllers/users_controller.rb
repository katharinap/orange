class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @chart = ExerciseChart.new(@user)
  end
end
