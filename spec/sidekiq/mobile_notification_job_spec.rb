require "rails_helper"

RSpec.describe MobileNotificationJob, type: :job do
  let(:notification) { create(:mobile_notification) }
  let(:mobile_tokens) { create_list(:mobile_token, 3, platform: notification.platform, app_version: "2.0.0", active: true) }
  let(:push_notification_service) { PushNotificationService.new(notification) }
  let(:result) { { success_count: 2, failure_count: 1, detail: "Some detail" } }

  before do
    allow(PushNotificationService).to receive(:new).and_return(push_notification_service)
    allow(push_notification_service).to receive(:notify_all).and_return(result)
  end

  describe "#perform" do
    context "when notification exists" do
      it "finds the notification and processes it" do
        expect(MobileNotification).to receive(:find_by).with(id: notification.id).and_return(notification)
        expect(notification).to receive(:update_columns).with(
          success_count: result[:success_count],
          failure_count: result[:failure_count],
          status: :delivered,
          detail: result[:detail]
        )

        described_class.new.perform(notification.id)
      end

      it "calls push_notifications and update_notification methods" do
        expect_any_instance_of(described_class).to receive(:push_notifications)
        expect_any_instance_of(described_class).to receive(:update_notification)

        described_class.new.perform(notification.id)
      end
    end

    context "when notification does not exist" do
      it "does not process the notification" do
        expect(MobileNotification).to receive(:find_by).with(id: 999).and_return(nil)
        expect_any_instance_of(described_class).not_to receive(:push_notifications)
        expect_any_instance_of(described_class).not_to receive(:update_notification)

        described_class.new.perform(999)
      end
    end
  end

  describe "#mobile_tokens" do
    let(:job) { described_class.new }

    before do
      job.instance_variable_set(:@notification, notification)
    end

    it "returns active mobile tokens for the notification platform" do
      mobile_tokens.first.update(active: false)

      expect(job.send(:mobile_tokens).count).to eq(2)
    end

    context "when there are matching app_version and active 2 tokens" do
      it "returns mobile tokens with the correct platform and app versions" do
        mobile_tokens.first.update(active: false)
        notification.update(app_versions: ["2.0.0"])

        expect(job.send(:mobile_tokens).count).to eq(2)
      end
    end

    context "when there are no matching app_version" do
      it "returns mobile tokens with the correct platform and app versions" do
        notification.update(app_versions: ["1.0.0"])

        expect(job.send(:mobile_tokens).count).to eq(0)
      end
    end
  end

  describe "#push_notifications" do
    it "calls PushNotificationService to notify all mobile tokens" do
      job = described_class.new
      job.instance_variable_set(:@notification, notification)

      expect(push_notification_service).to receive(:notify_all).with(mobile_tokens)

      job.send(:push_notifications)
    end
  end

  describe "#update_notification" do
    it "updates the notification with the result of push notifications" do
      job = described_class.new
      job.instance_variable_set(:@notification, notification)
      job.instance_variable_set(:@result, result)

      expect(notification).to receive(:update_columns).with(
        success_count: result[:success_count],
        failure_count: result[:failure_count],
        status: :delivered,
        detail: result[:detail]
      )

      job.send(:update_notification)
    end
  end
end
