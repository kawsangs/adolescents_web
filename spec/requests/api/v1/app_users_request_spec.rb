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
      gender: "male", age: 20, province_id: "01", registered_at: DateTime.yesterday, device_id: "123", platform: "ios",
      occupation: "student", education_level: "general_knowledge",
      app_user_characteristics_attributes: [
        { characteristic_attributes: { code: "PO" } },
        { characteristic_attributes: { code: "IP" } },
        { characteristic_attributes: { code: "DI" } }
      ]
    }}

    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }

    describe "POST #create" do
      it "creates an app user" do
        expect { post "/api/v1/app_users", params: { app_user: valid_params }, headers: }
              .to change { AppUser.count }.by 1
      end

      it "creates an app user" do
        post "/api/v1/app_users", params: { app_user: valid_params }, headers: headers

        expect(AppUser.last.platform).to eq("ios")
      end

      it "creates 3 user characteristics" do
        expect { post "/api/v1/app_users", params: { app_user: valid_params }, headers: }
              .to change { AppUserCharacteristic.count }.by 3
      end
    end

    describe "PUT #update" do
      let!(:anonymous_user) { create(:app_user, :anonymous) }

      it "updates the app user" do
        expect { put "/api/v1/app_users/#{anonymous_user.id}", params: { app_user: valid_params }, headers: }
              .to change { anonymous_user.reload.age }.from(-1).to(20)
      end
    end

    describe "DELETE #destroy" do
      let!(:anonymous_user) { create(:app_user, :anonymous) }

      it "destroys the user and returns a success response" do
        delete "/api/v1/app_users/#{anonymous_user.id}", headers: headers

        expect(response.status).to eq(200)
        expect(response.body).to eq({ message: "User is deleted successfully" }.to_json)
        expect(AppUser.find_by uuid: anonymous_user.uuid).to be_nil
      end

      it "returns an error response if the user is not found" do
        delete "/api/v1/app_users/0", headers: headers

        expect(response.status).to eq(404)
      end
    end
  end
end
