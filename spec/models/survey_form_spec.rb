require "rails_helper"

RSpec.describe Topics::SurveyForm, type: :model do
  # Test inheritance
  it { is_expected.to be_a(::Topic) }

  # Test Associations
  describe 'associations' do
    it { is_expected.to have_many(:mobile_notifications).with_foreign_key(:topic_id) }
    it { is_expected.to have_many(:questions).through(:sections) }
    it { is_expected.to have_many(:surveys).class_name('Survey').with_foreign_key(:topic_id) }
  end

  describe '.policy_class' do
    it 'returns SurveyFormPolicy' do
      expect(described_class.policy_class).to eq(SurveyFormPolicy)
    end
  end

  describe "#deep_copy" do
    let(:survey) do
      create(:survey_form, name_en: "Test Survey", name_km: "សាកល្បង", code: "TS", tag_list: ["survey", "test"])
    end
    let!(:section) { create(:section, topic: survey, name: "Section 1") }
    let!(:question) do
      create(:question, section:, topic: survey, name: "Question 1", code: "q1", audio: File.open("spec/fixtures/sample.mp3"))
    end
    let!(:option) do
      create(:option, question:, name: "Option 1", value: "opt1", image: File.open("spec/fixtures/sample.png"))
    end
    let!(:criteria) { create(:criteria, question:) }
    let!(:notification) { create(:mobile_notification, topic_id: survey.id) }

    it "creates a new survey with copied attributes" do
      allow(Time.zone).to receive(:now).and_return(Time.parse("2025-05-03 12:34:56"))

      new_survey = survey.deep_copy
      expect(new_survey).not_to eq(survey)
      expect(new_survey.name_en).to eq("Test Survey (2025-05-03-12-34-56)")
      expect(new_survey.name_km).to eq("សាកល្បង (2025-05-03-12-34-56)")
      expect(new_survey.code).to eq("TS") # Unchanged
      expect(new_survey.tag_list).to eq("[\"survey\", \"test\"]") # Copied tags
      expect(new_survey.version).to eq(0)
      expect(new_survey.published_at).to be_nil
    end

    it "copies sections with correct topic_id" do
      new_survey = survey.deep_copy
      expect(new_survey.sections.count).to eq(1)
      new_section = new_survey.sections.reload.first
      expect(new_section.name).to eq("Section 1")
      expect(new_section.topic_id).to eq(new_survey.id)
    end

    it "copies questions with audio and preserves code and name" do
      new_survey = survey.deep_copy
      expect(new_survey.questions.count).to eq(1)
      new_question = new_survey.questions.first
      expect(new_question.name).to eq("Question 1") # Unchanged
      expect(new_question.code).to eq("q1") # Unchanged
      expect(new_question.topic_id).to eq(new_survey.id)
      expect(new_question.section_id).to eq(new_survey.sections.reload.first.id)
      expect(new_question.audio_url).to be_present
      expect(new_question.audio.url).not_to eq(question.audio.url) # Different file path
    end

    it "copies options with image and preserves value" do
      new_survey = survey.deep_copy
      expect(new_survey.questions.first.options.count).to eq(1)
      new_option = new_survey.questions.first.options.first
      expect(new_option.name).to eq("Option 1")
      expect(new_option.value).to eq("opt1") # Unchanged
      expect(new_option.question_id).to eq(new_survey.questions.first.id)
      expect(new_option.image).to be_present
      expect(new_option.image.url).not_to eq(option.image.url) # Different file path
    end

    it "copies criterias with correct question_id" do
      new_survey = survey.deep_copy
      expect(new_survey.questions.first.criterias.count).to eq(1)
      new_criteria = new_survey.questions.first.criterias.first
      expect(new_criteria.question_id).to eq(new_survey.questions.first.id)
    end

    it "does not copy mobile notifications" do
      new_survey = survey.deep_copy
      expect(new_survey.mobile_notifications.count).to eq(0)
    end

    context "when question has no audio" do
      let!(:question) { create(:question, section:, topic: survey, name: "Question 1", code: "q1") }

      it "copies questions without audio" do
        new_survey = survey.deep_copy
        new_question = new_survey.questions.first
        expect(new_question.audio.present?).to be_falsey
        expect(new_question.name).to eq("Question 1")
        expect(new_question.code).to eq("q1")
      end
    end

    context "when option has no image" do
      let!(:option) { create(:option, question:, name: "Option 1", value: "opt1") }

      it "copies options without image" do
        new_survey = survey.deep_copy
        new_option = new_survey.questions.first.options.first
        expect(new_option.image.present?).to be_falsey
        expect(new_option.name).to eq("Option 1")
        expect(new_option.value).to eq("opt1")
      end
    end

    context "when validation fails" do
      before do
        # Simulate a validation failure by stubbing save! on Section
        allow_any_instance_of(Section).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(section))
      end

      it "raises an error and rolls back" do
        expect(survey.deep_copy).to be_falsey
        expect(Topics::SurveyForm.count).to eq(1) # No new survey created
      end
    end
  end
end
