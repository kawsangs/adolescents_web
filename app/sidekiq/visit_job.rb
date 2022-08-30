class VisitJob
  include Sidekiq::Job

  def perform(params = {})
    Visit.create(visit_params(params))
  end

  private
    def visit_params(params)
      ActionController::Parameters.new(params)
        .permit(
          :device_id, :visit_date,
          page_attributes: [:code, :name, :parent_code],
          platform_attributes: [:name]
        )
    end
end
