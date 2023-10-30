# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::SurveyFormsController", type: :request do
  describe "GET #show" do
    let!(:api_key) { create(:api_key) }
    let!(:form)    { create(:survey_form) }
    let(:json_response) { JSON.parse(response.body) }

    before {
      headers = { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" }
      get "/api/v1/survey_forms/#{form.id}", headers:
    }

    it { expect(response.status).to eq(200) }
    it { expect(json_response["id"]).not_to be_nil }
  end
end
