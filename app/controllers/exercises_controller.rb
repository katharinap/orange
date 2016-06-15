class ExercisesController < ApplicationController
  before_action :set_exercise, except: %i(index new create)

  def index
    set_chart
  end

  def edit
    @permitted = @exercise.user == current_user
    respond_to do |format|
      format.js
    end
  end

  def new
    @exercise = Exercise.new(type: params[:type],
                             user: current_user,
                             date: today)
    @permitted = true
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        set_chart
        flash[:notice] = 'Exercise successfully updated.'
        format.js { render 'charts/refresh' }
      else
        @permitted = true
        format.js { render :edit }
      end
    end
  end

  def create
    @exercise = Exercise.new(exercise_params)
    if @exercise.save
      flash[:notice] = 'Exercise successfully created.'
    else
      flash[:error] = 'Failed to create exercise.'
    end
    set_chart
    respond_to do |format|
      format.js { render 'charts/refresh' }
    end
  end

  def destroy
    respond_to do |format|
      @exercise.destroy
      flash[:notice] = 'Exercise successfully deleted.'
      set_chart
      format.js { render 'charts/refresh' }
    end
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def set_chart
    @multi_user = !params[:user_id]
    if @multi_user
      @chart = ExerciseChart.new(*User.relevant)
    else
      @user = User.find(params[:user_id])
      @chart = ExerciseChart.new(@user)
    end
  end

  def exercise_params
    params.require(:exercise)
          .permit(:date, :repetitions, :duration, :type, :user_id)
  end
end
