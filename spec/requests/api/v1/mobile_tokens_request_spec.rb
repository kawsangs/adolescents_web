require "rails_helper"

RSpec.describe "Api::V1::MobileTokensController", type: :request do
  describe "GET #update" do
    let(:json_response) { JSON.parse(response.body) }
    let(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }

    context "new device_id" do
      let(:params) { { token: "abcd", device_id: "a1b2", device_type: "mobile", app_version: "1.0.1" } }

      it "creates a mobile_token" do
        expect {
          post "/api/v1/mobile_tokens", params: { mobile_token: params }, headers:
        }.to change { MobileToken.count }.by (1)
      end
    end

    context "existing device_id" do
      let!(:mobile_token) { create(:mobile_token, token: "aaaa", device_id: "a1b2") }
      let!(:params) { { token: "abcdefg", device_id: "a1b2", device_type: "mobile", app_version: "1.0.1" } }

      it "doesn't creates a mobile_token" do
        expect {
          post "/api/v1/mobile_tokens", params: { mobile_token: params }, headers:
        }.to change { MobileToken.count }.by (0)
      end

      it "update the mobile_token" do
        expect {
          post "/api/v1/mobile_tokens", params: { mobile_token: params }, headers:
        }.to change { mobile_token.reload.token }.from("aaaa").to("abcdefg")
      end
    end
  end
end
