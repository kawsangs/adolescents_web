require "rails_helper"

RSpec.describe "Api::V1::CategoriesController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:category) { create(:category) }

    before :each do
      get "/api/v1/categories", headers:
    end

    it "returns code 200" do
      expect(response.code).to eq("200")
    end

    it "returns collection of categories" do
      expect(json_response["categories"].length).to eq(1)
    end
  end
end
