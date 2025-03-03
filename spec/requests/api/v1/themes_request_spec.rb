require "rails_helper"

RSpec.describe "Api::V1::ThemesController", type: :request do
  let(:api_key) { create(:api_key) }
  let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
  let(:json_response) { JSON.parse(response.body) }
  let!(:theme1) { create(:theme, active: false) }
  let!(:theme2) { create(:theme, active: true) }

  describe "GET /api/v1/themes" do
    before :each do
      get "/api/v1/themes", headers:
    end

    it "returns collection of themes" do
      expect(response).to have_http_status(:success)
      expect(json_response["themes"].length).to eq(1)
      expect(json_response["pagy"]).to be_present
    end
  end

  describe "GET /api/v1/themes/:id" do
    let(:theme1) { create(:theme, active: true) }
    let(:theme2) { create(:theme, active: false) }

    context "when theme exists" do
      it "returns the theme" do
        get "/api/v1/themes/#{theme1.id}", headers: headers

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response["id"]).to eq(theme1.id)
        expect(json_response["name"]).to eq(theme1.name)
      end
    end

    context "when theme does not exist" do
      it "returns a not found error" do
        get "/api/v1/themes/9999", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when theme is inactive" do
      it "returns a not found error" do
        get "/api/v1/themes/#{theme2.id}", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
