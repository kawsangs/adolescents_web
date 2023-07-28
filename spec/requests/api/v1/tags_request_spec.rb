require "rails_helper"

RSpec.describe "Api::V1::TagsController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:tag) { create(:tag) }
    let!(:facility) { create(:facility, tag_ids: [tag.id]) }

    before :each do
      get "/api/v1/tags", headers:
    end

    it "returns collection of tags" do
      expect(json_response["tags"].length).to eq(1)
    end
  end
end
