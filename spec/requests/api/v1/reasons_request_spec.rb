require "rails_helper"

RSpec.describe "Api::V1::ReasonsController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:reason) { create(:reason) }

    before :each do
      get "/api/v1/reasons", headers:
    end

    it "returns collection of reasons" do
      expect(json_response["reasons"].length).to eq(1)
    end
  end
end
