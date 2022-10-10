require "rails_helper"

RSpec.describe "Api::V1::TopicsController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:header) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:topic) { create(:topic, :published) }

    before :each do
      get "/api/v1/topics", headers:
    end

    it "returns collection of topics" do
      expect(json_response.length).to eq(1)
    end
  end
end
