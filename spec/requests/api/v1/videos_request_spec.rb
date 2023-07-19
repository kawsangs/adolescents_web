require "rails_helper"

RSpec.describe "Api::V1::VideosController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:video) { create(:video) }

    before :each do
      get "/api/v1/videos", headers:
    end

    it "returns collection of videos" do
      expect(json_response["videos"].length).to eq(1)
    end
  end
end
