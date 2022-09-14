require "rails_helper"

RSpec.describe VisitJob, type: :job do
  describe "perfom" do
    let!(:app_user) { create(:app_user, :anonymous) }
    let(:valid_params) { {
      app_user_id: app_user.id, visit_date: Time.now,
      page_attributes: { code: "page_one", name: "Page one", parent_code: nil },
      platform_attributes: { name: "android" }
    }}

    before {
      subject.perform(valid_params.as_json)
    }

    it "create a visit" do
      expect(Visit.count).to eq(1)
    end

    it "create a page" do
      expect(Page.count).to eq(1)
    end

    it "create a platform" do
      expect(Platform.count).to eq(1)
    end
  end
end
