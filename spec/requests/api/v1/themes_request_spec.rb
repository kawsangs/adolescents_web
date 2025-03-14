require "rails_helper"

RSpec.describe "Api::V1::ThemesController", type: :request do
  let(:api_key) { create(:api_key) }
  let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
  let(:json_response) { JSON.parse(response.body) }

  describe "GET /api/v1/themes" do
    let!(:published_themes) { create_list(:theme, 3, :published) }
    let!(:draft_theme) { create(:theme) }

    context "without updated_at filter" do
      it "returns bad_request" do
        get "/api/v1/themes", headers: headers

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with valid updated_at filter" do
      let!(:old_theme) { create(:theme, :published, updated_at: Time.at(1640995200)) } # Jan 1, 2022
      let!(:new_theme) { create(:theme, :published, updated_at: Time.now) }

      it "returns themes updated after the provided timestamp" do
        get "/api/v1/themes", params: { updated_at: 1640995200 }, headers: headers

        expect(response).to have_http_status(:ok)

        expect(json_response["pagy"]["count"]).to be > 0
        expect(json_response["themes"].map { |t| t["id"] }).to include(new_theme.id)
        expect(json_response["themes"].map { |t| t["id"] }).not_to include(old_theme.id)
      end
    end

    context "with invalid updated_at (negative)" do
      it "returns a bad request error" do
        get "/api/v1/themes", params: { updated_at: -1 }, headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(json_response["error"]).to eq("updated_at must be a valid epoch timestamp")
      end
    end

    context "with no published themes" do
      before { Theme.published.destroy_all }

      it "returns an empty list" do
        get "/api/v1/themes", params: { updated_at: 1640995200 }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response["pagy"]["count"]).to eq(0)
        expect(json_response["themes"]).to be_empty
      end
    end
  end

  describe "GET /api/v1/themes/:id" do
    let!(:theme) { create(:theme, :published, :with_assets) }

    context "with a valid theme ID" do
      it "returns the theme details" do
        get "/api/v1/themes/#{theme.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response).to include(
          "id" => theme.id,
          "name" => theme.name,
          "updated_at" => theme.updated_at.to_i
        )
        expect(json_response["assets"].size).to eq(2)
      end
    end

    context "with an draft theme" do
      let!(:draft_theme) { create(:theme) }

      it "returns a not found error" do
        get "/api/v1/themes/#{draft_theme.id}", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("Theme not found")
      end
    end

    context "with a nonexistent theme ID" do
      it "returns a not found error" do
        get "/api/v1/themes/999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to eq("Theme not found")
      end
    end
  end
end
