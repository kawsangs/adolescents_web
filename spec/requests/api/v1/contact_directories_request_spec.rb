require "rails_helper"

RSpec.describe "Api::V1::ContactDirectoriesController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:contact_directory) { create(:contact_directory, :with_contacts) }

    before :each do
      get "/api/v1/contact_directories", headers:
    end

    it "returns collection of contact directories" do
      expect(json_response["contact_directories"].length).to eq(1)
    end
  end
end
