# == Schema Information
#
# Table name: survey_answers
#
#  id          :uuid             not null, primary key
#  survey_id   :uuid
#  question_id :uuid
#  option_id   :uuid
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  uuid        :string
#  voice       :string
#
require "rails_helper"

RSpec.describe SurveyAnswer, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:survey).optional }
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:option).optional }
  end

  describe "uploader" do
    it "mounts the AudioUploader for the voice attribute" do
      expect(subject.class.uploaders[:voice]).to eq(AudioUploader)
    end
  end

  describe "delegations" do
    let(:option) { create(:option, name: "Option 1", value: "value1") }
    let(:survey_answer) { create(:survey_answer, option:, question: option.question) }

    it "delegates name to option with prefix" do
      expect(survey_answer.option_name).to eq("Option 1")
    end

    it "delegates value to option with prefix" do
      expect(survey_answer.option_value).to eq("value1")
    end

    context "when option is nil" do
      let(:survey_answer) { create(:survey_answer, option: nil, question: create(:question)) }

      it "returns nil for option_name" do
        expect(survey_answer.option_name).to be_nil
      end

      it "returns nil for option_value" do
        expect(survey_answer.option_value).to be_nil
      end
    end
  end

  describe "callbacks" do
    describe "after_create :notify_telegram_groups" do
      let(:survey) { create(:survey) }
      let(:group1) { create(:chat_group) }
      let(:group2) { create(:chat_group) }
      let(:option) { create(:option, chat_groups: [group1, group2]) }
      let(:survey_answer) { build(:survey_answer, survey:, option:, question: option.question) }

      it "calls notify_groups_async on survey with option chat_groups" do
        expect(survey).to receive(:notify_groups_async).with([group1, group2])
        survey_answer.save
      end

      context "when option is nil" do
        let(:survey_answer) { build(:survey_answer, survey:, option: nil, question: create(:question)) }

        it "does not call notify_groups_async" do
          expect(survey).not_to receive(:notify_groups_async)
          survey_answer.save
        end
      end

      context "when option has no chat_groups" do
        let(:option) { create(:option, chat_groups: []) }
        let(:survey_answer) { build(:survey_answer, survey:, option:, question: option.question) }

        it "does not call notify_groups_async" do
          expect(survey).not_to receive(:notify_groups_async)
          survey_answer.save
        end
      end
    end
  end
end
