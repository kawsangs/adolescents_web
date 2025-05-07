# == Schema Information
#
# Table name: surveys
#
#  id                     :uuid             not null, primary key
#  app_user_id            :uuid
#  topic_id               :uuid
#  quizzed_at             :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  mobile_notification_id :integer
#
require "rails_helper"

RSpec.describe Survey, type: :model do
  describe "associations" do
    it { should belong_to(:topic) }
    it { should belong_to(:app_user) }
    it { should belong_to(:mobile_notification).optional }
    it { should have_many(:survey_answers).dependent(:destroy) }
  end

  describe "nested attributes" do
    it { should accept_nested_attributes_for(:survey_answers).allow_destroy(true) }
  end

  describe "#survey_answers_for" do
    let(:survey) { create(:survey) }
    let(:question) { create(:question) }
    let!(:survey_answer) { create(:survey_answer, survey:, question:) }

    it "returns the survey answer for a given question_id" do
      expect(survey.survey_answers_for(question.id)).to eq(survey_answer)
    end

    it "returns nil if no survey answer exists for the given question_id" do
      expect(survey.survey_answers_for("nonexistent_id")).to be_nil
    end
  end

  describe ".filter" do
    let!(:survey1) { create(:survey, created_at: DateTime.parse("2025-05-01 12:00")) }
    let!(:survey2) { create(:survey, created_at: DateTime.parse("2025-05-03 12:00"), topic: create(:topic)) }
    let!(:survey3) { create(:survey, created_at: DateTime.parse("2025-05-05 12:00")) }

    context "with start_date and end_date" do
      let(:params) do
        { start_date: "2025-05-01", end_date: "2025-05-03" }
      end

      it "returns surveys within the date range" do
        expect(Survey.filter(params)).to include(survey1, survey2)
        expect(Survey.filter(params)).not_to include(survey3)
      end
    end

    context "with survey_form_id" do
      let(:params) { { survey_form_id: survey2.topic_id } }

      it "returns surveys with the specified topic_id" do
        expect(Survey.filter(params)).to include(survey2)
        expect(Survey.filter(params)).not_to include(survey1, survey3)
      end
    end

    context "with no params" do
      it "returns all surveys" do
        expect(Survey.filter).to include(survey1, survey2, survey3)
      end
    end

    context "with invalid date params" do
      let(:params) { { start_date: "invalid", end_date: "2025-05-03" } }

      it "raises an error for invalid dates" do
        expect { Survey.filter(params) }.to raise_error(Date::Error)
      end
    end
  end

  describe "included concerns" do
    it "includes Surveys::NotifiableConcern" do
      expect(Survey.ancestors).to include(Surveys::NotifiableConcern)
    end
  end
end
