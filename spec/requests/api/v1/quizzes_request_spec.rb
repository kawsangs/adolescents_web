require "rails_helper"

RSpec.describe "Api::V1::QuizzesController", type: :request do
  describe "POST #create" do
    let!(:api_key) { create(:api_key) }
    let(:headers) { { "ACCEPT" => "application/json", "Authorization" => "Apikey #{api_key.api_key}" } }
    let(:json_response) { JSON.parse(response.body) }

    let!(:topic)     { create(:topic, :published) }
    let!(:question1) { create(:question_with_options, topic:) }
    let!(:question2) { create(:question_with_options, topic:) }
    let!(:option1_1) { question1.options.first }
    let!(:option2_1) { question2.options.first }
    let!(:app_user)  { create(:app_user) }

    let(:valid_params) { {
      app_user_id: app_user.id,
      topic_id: topic.id,
      quizzed_at: DateTime.yesterday,
      answers_attributes: [
        {
          question_id: question1.id,
          option_id: option1_1.id,
          value: option1_1.name
        },
        {
          question_id: question2.id,
          option_id: option2_1.id,
          value: option2_1.name
        }
      ]
    }}

    it "creates a quiz" do
      expect { post "/api/v1/quizzes", params: { quiz: valid_params }, headers: }
            .to change { Survey.count }.by 1
    end

    it "creates 2 answers" do
      expect { post "/api/v1/quizzes", params: { quiz: valid_params }, headers: }
            .to change { SurveyAnswer.count }.by 2
    end
  end
end
