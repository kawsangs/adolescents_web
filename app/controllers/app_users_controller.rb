class AppUsersController < ApplicationController
  def index
    @pagy, @app_users = pagy(authorize AppUser.filter(filter_params).includes(app_user_characteristics: :characteristic))
  end

  private
    def filter_params
      params.permit(:start_date, :end_date)
    end
end
