require "rails_helper"

RSpec.describe AppUsers::ScheduleDeletionConcern, type: :model do
  let!(:app_user) { create(:app_user, :poor) }
  let!(:visit) { create(:visit, app_user:) }
  let!(:survey) { create(:survey, app_user:) }

  describe "#after_destroy, #schedule_real_destroy" do
    before { app_user.destroy }

    it { expect(app_user.send(:removing_date)).to eq(app_user.deleted_at + AppUser::REMOVING_PERIOD.days) }

    it "hides user and keep association" do
      expect(app_user.visits.present?).to be_truthy
      expect(app_user.surveys.present?).to be_truthy
      expect(app_user.app_user_characteristics.present?).to be_truthy
    end

    it "schedules really destroy date" do
      expect(AppUserDeletionJob.jobs.count).to eq(1)
    end
  end

  describe "#after_real_destroy, #remove_association" do
    it "deletes user and its association" do
      app_user.really_destroy!

      expect(app_user.visits.present?).to be_falsey
      expect(app_user.surveys.present?).to be_falsey
      expect(app_user.app_user_characteristics.present?).to be_falsey
    end
  end
end
