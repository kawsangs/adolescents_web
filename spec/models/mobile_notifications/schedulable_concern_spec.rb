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

RSpec.describe MobileNotifications::SchedulableConcern, type: :model do
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

  describe "#removeable?" do
    context "schedule date is in past tense" do
      subject { build(:mobile_notification, schedule_date: Time.zone.now - 1.minutes) }

      it { expect(subject.removeable?).to be_falsey }
    end

    context "schedule date is in the future" do
      subject { build(:mobile_notification, schedule_date: Time.zone.now + 20.minutes) }

      it { expect(subject.removeable?).to be_truthy }
    end
  end

  describe "#validate_schedule_at" do
    context "schedule_at is blank" do
      subject { build(:mobile_notification, schedule_at: nil) }

      it { expect(subject.valid?).to be_truthy }
    end

    context "schedule_at is right format" do
      subject { build(:mobile_notification, schedule_at: "#{Time.zone.now + 20.minutes}") }

      it "sets schedule_date" do
        subject.valid?
        expect(subject.schedule_date).to eq(Time.zone.parse(subject.schedule_at))
      end
    end

    context "schedule_at is wrong format" do
      subject { build(:mobile_notification, schedule_at: "2023-100-10") }

      it "has schedule_date errors invalid" do
        subject.valid?
        expect(subject.errors[:schedule_date]).to include "is invalid format"
      end
    end
  end

  describe "#schedule_date_cannot_be_in_the_past" do
    context "schedule_date is blank" do
      subject { build(:mobile_notification, schedule_date: nil) }

      it "doens't have error on schedule_date" do
        subject.valid?
        expect(subject.errors).not_to include(:schedule_date)
      end
    end

    context "schedule_date is smaller than current time + 5mn" do
      subject { build(:mobile_notification, schedule_date: Time.zone.now + 4.minutes) }

      it "has error on schedule_date" do
        subject.valid?
        expect(subject.errors).to include(:schedule_date)
      end
    end

    context "schedule_date is bigger than current time + 5mn" do
      subject { build(:mobile_notification, schedule_date: Time.zone.now + 6.minutes) }

      it "doens't have error on schedule_date" do
        subject.valid?
        expect(subject.errors).not_to include(:schedule_date)
      end
    end
  end
end
