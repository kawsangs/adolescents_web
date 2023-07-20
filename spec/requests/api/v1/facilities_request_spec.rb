require "rails_helper"

RSpec.describe "Api::V1::FacilitiesController", type: :request do
  describe "GET #inde" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:facility) { create(:facility) }

    before :each do
      get "/api/v1/facilities", headers:
    end

    it "returns collection of videos" do
      expect(json_response["facilities"].length).to eq(1)
    end
  end
end
