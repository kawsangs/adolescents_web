require "rails_helper"

RSpec.describe "Api::V1::VideoAuthorsController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:video_author) { create(:video_author) }

    before :each do
      get "/api/v1/video_authors", headers:
    end

    it "returns collection of videos" do
      expect(json_response["video_authors"].length).to eq(1)
    end
  end
end
