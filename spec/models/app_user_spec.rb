# == Schema Information
#
# Table name: app_users
#
#  id               :uuid             not null, primary key
#  gender           :string
#  age              :integer
#  province_id      :string
#  registered_at    :datetime
#  device_id        :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_accessed_at :datetime
#  platform         :integer          default("android")
#  occupation       :integer          default("n_a")
#  education_level  :integer          default("n_a")
#  uuid             :string
#  deleted_at       :datetime
#
require "rails_helper"

RSpec.describe AppUser, type: :model do
  it { is_expected.to validate_presence_of(:age) }
  it { is_expected.to validate_presence_of(:device_id) }
  it { is_expected.to validate_presence_of(:registered_at) }

  it { is_expected.to have_many(:app_user_characteristics).dependent(:destroy) }
  it { is_expected.to have_many(:characteristics).through(:app_user_characteristics) }

  describe "#anonymous?" do
    it "returns true" do
      subject.age = -1

      expect(subject.anonymous?).to be_truthy
    end

    it "returns false" do
      subject.age = 10

      expect(subject.anonymous?).to be_falsey
    end
  end

  describe "validation #gender" do
    subject { described_class.new(gender: nil) }

    context "normal user" do
      it "requires gender" do
        allow(subject).to receive(:anonymous?).and_return false
        subject.valid?

        expect(subject.errors.messages).to include :gender
      end

      it "validate inclusion" do
        subject.gender = "invalid"
        subject.valid?

        expect(subject.errors.messages[:gender]).to include "is not included in the list"
      end
    end

    context "anonymous" do
      it "doens't require gender" do
        allow(subject).to receive(:anonymous?).and_return true
        subject.valid?

        expect(subject.errors.messages).not_to include :gender
      end
    end
  end

  describe "validation #occupation" do
    subject { described_class.new(occupation: nil) }

    context "normal user" do
      it "requires occupation" do
        allow(subject).to receive(:anonymous?).and_return false
        subject.valid?

        expect(subject.errors.messages).to include :occupation
      end
    end

    context "anonymous" do
      it "doens't require occupation" do
        allow(subject).to receive(:anonymous?).and_return true
        subject.valid?

        expect(subject.errors.messages).not_to include :occupation
      end
    end
  end

  describe "validation #education_level" do
    subject { described_class.new(education_level: nil) }

    context "normal user" do
      it "requires education_level" do
        allow(subject).to receive(:anonymous?).and_return false
        subject.valid?

        expect(subject.errors.messages).to include :education_level
      end
    end

    context "anonymous" do
      it "doens't require education_level" do
        allow(subject).to receive(:anonymous?).and_return true
        subject.valid?

        expect(subject.errors.messages).not_to include :education_level
      end
    end
  end

  describe "#before_create, #set_last_accessed_at" do
    let!(:app_user) { create(:app_user, registered_at: DateTime.now) }

    it { expect(app_user.last_accessed_at).to eq(app_user.registered_at) }
  end

  describe "#before_validation, #set_province_id" do
    let!(:app_user) { build(:app_user, :anonymous, registered_at: DateTime.now) }

    before {
      app_user.valid?
    }

    it { expect(app_user.province_id).to eq(Location::UNKNOWN_PROVINCE_ID) }
  end
end
