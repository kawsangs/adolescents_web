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
#
require "rails_helper"

RSpec.describe MobileNotifications::Callback, type: :model do
  describe "before_create, #set_schedule_date" do
    context "schedule_date is nil" do
      subject { build(:mobile_notification, schedule_date: nil) }

      it "sets schedule_date to current time" do
        subject.save
        expect(subject.schedule_date).not_to be_nil
      end
    end

    context "schedule_date is not nil" do
      let!(:schedule_date) { DateTime.tomorrow.in_time_zone }
      subject { build(:mobile_notification, schedule_date:) }

      it "sets schedule_date to current time" do
        subject.save
        expect(subject.schedule_date).to eq schedule_date
      end
    end
  end

  describe "before_destroy, #validate_schedule_date" do
    context "removeable? is true" do
      subject { create(:mobile_notification) }

      before {
        allow(subject).to receive(:removeable?).and_return(true)
      }

      it "deletes schedule from sidekiq" do
        expect(subject).to receive(:delete_schedule)
        subject.destroy
      end
    end
  end
end
