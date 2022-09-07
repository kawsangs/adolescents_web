class VisitJob
  include Sidekiq::Job

  def perform(params = {})
    Visit.create(visit_params(params))
  end

  private
    def visit_params(params)
      ActionController::Parameters.new(params)
        .permit(
          :app_user_id, :visit_date,
          page_attributes: [:code, :name, :parent_code],
          platform_attributes: [:name]
        )
    end
end
