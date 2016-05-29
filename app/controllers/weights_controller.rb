class WeightsController < ApplicationController
  before_action :set_user_stat, except: %i(index new create)

  def index
    @user = User.find(params[:user_id])
    @chart = WeightChart.new(@user)
  end

  def new
    @user = User.find(params[:user_id])
    @user_stat = @user.user_stats.build(date: Date.current,
                                        weight: @user.current_weight)
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def create
    @user_stat = UserStat.new(user_stat_params)
    if @user_stat.save
      redirect_to user_weights_path(current_user, notice: 'Entry was created.')
    else
      redirect_to user_weights_path(current_user, error: 'Failed to add entry.')
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @user_stat.update(user_stat_params)
      redirect_to user_weights_path(current_user, notice: 'Entry was updated.')
    else
      render :edit
    end
  end

  def destroy
    @user_stat.destroy
    redirect_to user_weights_path(current_user, notice: 'Entry was deleted.')
  end

  private

  def set_user_stat
    @user_stat = UserStat.find(params[:id])
  end

  def user_stat_params
    params.require(:user_stat)
          .permit(:date, :weight, :user_id)
  end
end
