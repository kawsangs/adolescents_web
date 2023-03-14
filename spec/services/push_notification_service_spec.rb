require "rails_helper"

RSpec.describe PushNotificationService, type: :model do
  describe "#notify" do
    let!(:mobile_token_android) { create(:mobile_token) }
    let!(:mobile_token_ios)    { create(:mobile_token, :ios) }
    let!(:mobile_notification) { create(:mobile_notification) }

    let(:service) { described_class.new }

    context "success" do
      before {
        allow(service).to receive_message_chain(:fcm, :send_v1).and_return({ status_code: 200 })
      }

      it "gives detail success: ios + 1" do
        service.notify(mobile_token_ios, mobile_notification)

        expect(service.success_count).to eq(1)
        expect(service.failure_count).to eq(0)
        expect(service.detail[:success][:ios]).to eq(1)
      end

      it "gives detail success: android + 1" do
        service.notify(mobile_token_android, mobile_notification)

        expect(service.success_count).to eq(1)
        expect(service.failure_count).to eq(0)
        expect(service.detail[:success][:android]).to eq(1)
      end
    end

    context "failure" do
      before {
        allow(service).to receive_message_chain(:fcm, :send_v1).and_return({ status_code: 404 })
      }

      it "gives detail failure: ios + 1" do
        service.notify(mobile_token_ios, mobile_notification)

        expect(service.success_count).to eq(0)
        expect(service.failure_count).to eq(1)
        expect(service.detail[:failure][:ios]).to eq(1)
      end

      it "gives detail failure: android + 1" do
        service.notify(mobile_token_android, mobile_notification)

        expect(service.success_count).to eq(0)
        expect(service.failure_count).to eq(1)
        expect(service.detail[:failure][:android]).to eq(1)
      end
    end
  end
end
