class QuizzesController < ApplicationController
  before_action :assign_app_user

  def index
    @pagy, @quizzes = pagy(@app_user.quizzes.includes(:answers, :app_user, :topic))
  end

  def show
    @quiz = @app_user.quizzes.find(params[:id])
  end

  private
    def assign_app_user
      @app_user = AppUser.find(params[:app_user_id])
    end
end
