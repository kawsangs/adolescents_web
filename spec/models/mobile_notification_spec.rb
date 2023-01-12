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

RSpec.describe MobileNotification, type: :model do
  it { is_expected.to belong_to(:creator).with_foreign_key(:creator_id).class_name("User") }

  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(64) }
  it { is_expected.to validate_length_of(:body).is_at_most(255) }

  describe "#removeable?" do
    context "no schedule date" do
      subject { build(:mobile_notification, schedule_date: nil) }

      it { expect(subject.removeable?).to be_falsey }
    end

    context "schedule date is in past tense" do
      subject { build(:mobile_notification, schedule_date: DateTime.parse("2023-01-12 11:50")) }

      before {
        allow(Time).to receive(:now).and_return(DateTime.parse("2023-01-12 12:00"))
      }

      it { expect(subject.removeable?).to be_falsey }
    end

    context "schedule date is in the future" do
      subject { build(:mobile_notification, schedule_date: DateTime.parse("2023-01-12 12:30")) }

      before {
        allow(Time).to receive(:now).and_return(DateTime.parse("2023-01-12 12:00"))
      }

      it { expect(subject.removeable?).to be_truthy }
    end
  end
end
