class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @push_ups = @user.push_ups.order(:date)
    @sit_ups = @user.sit_ups.order(:date)
    @new_push_up = @user.push_ups.build
    @new_sit_up = @user.sit_ups.build
  end
end
