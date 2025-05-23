require "rails_helper"

RSpec.describe "Api::V1::VisitsController", type: :request do
  describe "POST #create" do
    let(:api_key) { create(:api_key) }
    let(:json_response) { JSON.parse(response.body) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:valid_params) { {
      app_user_id: SecureRandom.uuid, visit_date: Time.now,
      pageable_id: "", pageable_type: "Page",
      page_attributes: { code: "page_one", name: "Page one", parent_code: nil }
    }}

    before :each do
      post "/api/v1/visits", params: { visit: valid_params }, headers:
    end

    it "add a visit job" do
      expect(VisitJob.jobs.count).to eq(1)
    end

    it "render status created" do
      expect(response.status).to eq(201)
    end
  end
end
