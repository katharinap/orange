class CoursesController < ApplicationController
  before_action :set_course, except: %i(index new create)

  def index
    @user = User.find(params[:user_id])
    respond_to do |format|
      format.html
      format.json do
        render json: @user.courses.to_json
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def new
    @course = Course.new(user: current_user, date: Date.current)
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    if @course.update(course_params)
      redirect_to user_courses_path(current_user, notice: 'Course was updated.')
    else
      render :edit
    end
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to user_courses_path(current_user, notice: 'Course was created.')
    else
      redirect_to user_courses_path(current_user, error: 'Failed to create course.')
    end
  end

  def destroy
    @course.destroy
    redirect_to user_courses_path(current_user, notice: 'Course was deleted.')
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:date, :name, :user_id)
  end
end
