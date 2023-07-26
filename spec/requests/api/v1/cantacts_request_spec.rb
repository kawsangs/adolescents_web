require "rails_helper"

RSpec.describe "Api::V1::ContactsController", type: :request do
  describe "GET #index" do
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }
    let!(:contact) { create(:contact) }

    before :each do
      get "/api/v1/contacts", headers:
    end

    it "returns collection of contacts" do
      expect(json_response["contacts"].length).to eq(1)
    end
  end
end
