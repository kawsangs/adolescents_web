# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::AppUsersController", type: :request do
  describe "POST #create" do
    let!(:api_key) { create(:api_key) }
    let(:json_response) { JSON.parse(response.body) }
    let!(:poor) { create(:characteristic, :poor) }
    let!(:minority) { create(:characteristic, :minority) }
    let!(:disablity) { create(:characteristic, :disablity) }

    let(:valid_params) { {
      gender: "male", age: 20, province_id: "01", registered_at: DateTime.yesterday, device_id: "123",
      app_user_characteristics_attributes: [
        { characteristic_attributes: { code: "PO" } },
        { characteristic_attributes: { code: "MI" } },
        { characteristic_attributes: { code: "DI" } }
      ]
    }}

    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }

    it "creates an app user" do
      expect { post "/api/v1/app_users", params: { app_user: valid_params }, headers: }
            .to change { AppUser.count }.by 1
    end

    it "creates 3 user characteristics" do
      expect { post "/api/v1/app_users", params: { app_user: valid_params }, headers: }
            .to change { AppUserCharacteristic.count }.by 3
    end
  end
end
