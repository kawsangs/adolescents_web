class VisitJob
  include Sidekiq::Job

  def perform(params = {})
    visit = Visit.new(visit_params(params))
    visit.save if visit.last_visit.nil?
  end

  private
    def visit_params(params)
      ActionController::Parameters.new(params)
        .permit(
          :app_user_id, :visit_date, :facility_id,
          page_attributes: [:code, :name, :parent_code],
          platform_attributes: [:name]
        )
    end
end
