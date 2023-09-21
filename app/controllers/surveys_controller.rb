class SurveysController < ApplicationController
  before_action :assign_app_user

  def index
    @pagy, @surveys = pagy(policy_scope(@app_user.surveys.includes(:survey_answers, :app_user, :topic)))
  end

  def show
    @survey = authorize @app_user.surveys.find(params[:id])
  end

  private
    def assign_app_user
      @app_user = AppUser.find(params[:app_user_id])
    end
end
