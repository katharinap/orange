class HomeController < ApplicationController
  def index
    redirect_to exercises_path
  end
end
