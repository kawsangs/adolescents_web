# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::VisitorsController", type: :request do
  describe "POST #create" do
    let(:api_key) { create(:api_key) }
    let(:json_response) { JSON.parse(response.body) }
    let(:valid_params) { {
      divise_id: "123abc", visitor_date: Time.now,
      page_attributes: { code: "page_one", name: "Page one", parent_code: nil },
      platform_attributes: { name: "android" }
    }}

    before :each do
      headers = { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" }
      post "/api/v1/visitors", params: { visitor: valid_params }, headers:
    end

    it "create a visitor" do
      expect(Visitor.count).to eq(1)
    end

    it "create a page" do
      expect(Page.count).to eq(1)
    end

    it "create a platform" do
      expect(Platform.count).to eq(1)
    end
  end
end
