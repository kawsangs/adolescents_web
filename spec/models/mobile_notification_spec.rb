# == Schema Information
#
# Table name: mobile_notifications
#
#  id                           :bigint           not null, primary key
#  title                        :string
#  body                         :text
#  success_count                :integer
#  failure_count                :integer
#  creator_id                   :integer
#  app_versions                 :string           default([]), is an Array
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  platform                     :integer
#  schedule_date                :datetime
#  mobile_notification_batch_id :integer
#  job_id                       :string
#  status                       :integer          default("pending")
#  detail                       :json
#  topic_id                     :uuid
#
require "rails_helper"

RSpec.describe MobileNotification, type: :model do
  describe "enums" do
    it { is_expected.to define_enum_for(:platform).with_values(MobileToken.platforms) }
    it { is_expected.to define_enum_for(:status).with_values(pending: 1, delivered: 2) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:creator).class_name("User").with_foreign_key(:creator_id) }
    it { is_expected.to belong_to(:survey_form).class_name("Topics::SurveyForm").with_foreign_key(:topic_id).optional }
    it { is_expected.to have_many(:mobile_notification_logs) }
  end

  describe "validations" do
    subject { build(:mobile_notification) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(255) }
  end

  describe "callbacks" do
    describe "after_create :published_survey_form" do
      let(:survey_form) { create(:survey_form) }
      let(:mobile_notification) { build(:mobile_notification, topic_id: survey_form.id) }

      context "when topic_id is present and survey_form is not published" do
        it "publishes the survey form" do
          expect { mobile_notification.save }.to change { survey_form.reload.published? }.from(false).to(true)
        end
      end

      context "when topic_id is present and survey_form is already published" do
        let(:survey_form) { create(:survey_form, :published) }

        it "does not attempt to publish the survey form again" do
          expect(survey_form).not_to receive(:publish)
          mobile_notification.save
        end
      end

      context "when topic_id is not present" do
        let(:mobile_notification) { build(:mobile_notification, topic_id: nil) }

        it "does not attempt to publish any survey form" do
          expect_any_instance_of(Topics::SurveyForm).not_to receive(:publish)
          mobile_notification.save
        end
      end
    end
  end

  describe "delegation" do
    let(:survey_form) { create(:survey_form, name_km: "សំណុំបែបបទស្ទង់មតិ", name_en: "Survey Form") }
    let(:mobile_notification) { create(:mobile_notification, topic_id: survey_form.id) }

    it "delegates name to survey_form with prefix, using name_km" do
      expect(mobile_notification.survey_form_name).to eq("សំណុំបែបបទស្ទង់មតិ")
    end

    it "returns nil for survey_form_name when survey_form is nil" do
      mobile_notification = create(:mobile_notification, topic_id: nil)
      expect(mobile_notification.survey_form_name).to be_nil
    end
  end

  describe "#build_content" do
    let(:survey_form) { create(:survey_form) }

    let(:mobile_notification) do
      create(
        :mobile_notification,
        title: "Test Notification",
        body: "This is a test notification body",
        topic_id: survey_form.id
      )
    end

    subject(:content) { mobile_notification.build_content }

    it "returns a hash with the expected structure" do
      expect(content).to be_a(Hash)
      expect(content.keys).to contain_exactly(:data, :notification, :apns, :android)
    end

    it "includes payload with topic_id and mobile_notification_id in data" do
      payload = JSON.parse(content[:data][:payload])
      expect(payload["topic_id"]).to eq(mobile_notification.topic_id)
      expect(payload["mobile_notification_id"]).to eq(mobile_notification.id)
    end

    it "includes title and body in notification" do
      expect(content[:notification][:title]).to eq(mobile_notification.title)
      expect(content[:notification][:body]).to eq(mobile_notification.body)
    end

    it "includes correct APNS payload structure" do
      expect(content[:apns][:payload][:aps]).to eq({
        'content-available': 1,
        sound: "youthhealth.aiff"
      })
    end

    it "includes correct Android configuration" do
      expect(content[:android]).to eq({
        priority: "high",
        notification: {
          sound: "youthhealth",
          channelId: "youthhealth"
        }
      })
    end
  end

  describe ".filter" do
    let!(:survey_form1) { create(:survey_form) }
    let!(:survey_form2) { create(:survey_form) }
    let!(:notification1) { create(:mobile_notification, title: "First Notification", schedule_date: 10.minutes.from_now, topic_id: survey_form1.id) }
    let!(:notification2) { create(:mobile_notification, title: "Second Notification", schedule_date: 1.day.from_now, topic_id: survey_form2.id) }

    it "filters by title" do
      result = described_class.filter(title: "First")
      expect(result).to include(notification1)
      expect(result).not_to include(notification2)
    end

    it "filters by schedule_date range" do
      result = described_class.filter(start_date: Time.now.to_s, end_date: 1.hour.from_now.to_s)
      expect(result).to include(notification1)
      expect(result).not_to include(notification2)
    end

    it "filters by topic_id" do
      result = described_class.filter(topic_id: survey_form1.id)
      expect(result.to_a).to eq([notification1])
    end

    it "returns all records when no params are provided" do
      result = described_class.filter
      expect(result).to include(notification1, notification2)
    end
  end

  describe "private methods" do
    describe "#published_survey_form" do
      let(:survey_form) { create(:survey_form) }
      let(:mobile_notification) { create(:mobile_notification, topic_id: survey_form.id) }

      it "publishes the survey form if not published" do
        expect { mobile_notification.send(:published_survey_form) }
          .to change { survey_form.reload.published? }.from(false).to(true)
      end

      it "does not publish the survey form if already published" do
        survey_form = create(:survey_form, :published)
        mobile_notification = create(:mobile_notification, topic_id: survey_form.id)
        expect(survey_form).not_to receive(:publish)
        mobile_notification.send(:published_survey_form)
      end
    end
  end
end
