require "rails_helper"

RSpec.describe "Api::V1::ThemesController", type: :request do
  let(:api_key) { create(:api_key) }
  let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
  let(:json_response) { JSON.parse(response.body) }

  describe "GET #index" do
    let!(:published_themes) { create_list(:theme, 15, :with_assets, :published) }
    let!(:unpublished_theme) { create(:theme) }

    context "without from parameter" do
      it "returns paginated published themes" do
        get "/api/v1/themes", headers: headers

        expect(response).to have_http_status(:ok)

        expect(json_response["pagy"]["count"]).to eq(15)
        expect(json_response["pagy"]["items"]).to eq(10)
        expect(json_response["themes"].length).to eq(10)

        # Verify theme serialization includes expected attributes
        first_theme = json_response["themes"].first
        expect(first_theme).to include("id", "assets")
      end
    end

    context "with valid from parameter" do
      let(:timestamp) { 1.day.ago.to_i }

      it "returns themes from specified timestamp" do
        get "/api/v1/themes?from=#{timestamp}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response["themes"]).to be_present
      end
    end

    context "with invalid from parameter" do
      it "returns bad request for non-numeric timestamp" do
        get "/api/v1/themes?from=invalid", headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(json_response["error"]).to eq("from param must be a valid epoch timestamp")
      end

      it "returns bad request for out-of-range timestamp" do
        get "/api/v1/themes?from=293295235201", headers: headers # Beyond max limit

        expect(response).to have_http_status(:bad_request)
        expect(json_response["error"]).to eq("from param must be a valid epoch timestamp")
      end
    end
  end

  describe "GET #show" do
    context "with existing published theme" do
      let(:theme) { create(:theme, :published) }

      it "returns the theme" do
        get "/api/v1/themes/#{theme.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response["id"]).to eq(theme.id)
      end
    end

    context "with unpublished theme" do
      let(:theme) { create(:theme) }

      it "returns not found" do
        get "/api/v1/themes/#{theme.id}", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("Theme not found")
      end
    end

    context "with non-existent theme" do
      it "returns not found" do
        get "/api/v1/themes/9999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("Theme not found")
      end
    end
  end
end
