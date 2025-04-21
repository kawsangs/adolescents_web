# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::ThemeUsagesController, type: :request do
  let(:api_key) { create(:api_key) }
  let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
  let(:json_response) { JSON.parse(response.body) }

  describe "POST /api/v1/theme_usages" do
    let!(:app_user) { create(:app_user) }
    let!(:theme) { create(:theme) }

    let(:valid_params) do
      {
        theme_usage: {
          app_user_id: app_user.id,
          theme_id: theme.id,
          applied_at: DateTime.yesterday
        }
      }
    end

    context "with valid parameters" do
      it "creates a new app user theme" do
        expect {
          post "/api/v1/theme_usages", params: valid_params, headers:
        }.to change { ThemeUsage.count }.by(1)

        expect(response).to have_http_status(:created)
        expect(json_response).to include(
          "app_user_id" => app_user.id,
          "theme_id" => theme.id
        )
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          theme_usage: {
            app_user_id: app_user.id,
            theme_id: nil, # Invalid theme_id
            applied_at: DateTime.yesterday
          }
        }
      end

      it "does not create an app user theme and returns an error" do
        expect {
          post "/api/v1/theme_usages", params: invalid_params, headers:
        }.not_to change { ThemeUsage.count }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]["theme"]).to include("must exist")
      end
    end

    context "with invalid app_user_id" do
      let(:invalid_user_params) do
        {
          theme_usage: {
            app_user_id: -1, # Non-existent user
            theme_id: theme.id,
            applied_at: DateTime.yesterday
          }
        }
      end

      it "does not create an app user theme and returns an error" do
        expect {
          post "/api/v1/theme_usages", params: invalid_user_params, headers:
        }.not_to change { ThemeUsage.count }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]["app_user"]).to include("must exist")
      end
    end
  end
end
