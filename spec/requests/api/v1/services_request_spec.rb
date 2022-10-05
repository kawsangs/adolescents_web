require "rails_helper"

RSpec.describe "Api::V1::ServicesController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:header) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:service) { create(:service) }

    before :each do
      get "/api/v1/services", headers:
    end

    it "returns collection of services" do
      expect(json_response.length).to eq(1)
    end
  end
end
