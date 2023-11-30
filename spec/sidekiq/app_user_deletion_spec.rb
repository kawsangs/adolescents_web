require "rails_helper"

RSpec.describe AppUserDeletionJob, type: :job do
  describe "perfom" do
    let!(:app_user) { create(:app_user, :poor) }

    it "calls app_user really_destroy!" do
      subject.perform(app_user.id)

      expect(AppUser.with_deleted.find_by id: app_user.id).to be_nil
    end
  end
end
