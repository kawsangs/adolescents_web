# == Schema Information
#
# Table name: visits
#
#  id          :uuid             not null, primary key
#  page_id     :uuid
#  platform_id :uuid
#  visit_date  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  app_user_id :uuid
#
require "rails_helper"

RSpec.describe Visit, type: :model do
  describe "page_attributes=" do
    context "new page" do
      let(:page_attr) { { code: "page_one", name: "Page one", parent_code: nil } }
      let(:visit) { build(:visit) }

      it "create a new page" do
        expect { visit.page_attributes=(page_attr) }.to change { Page.count }.by 1
      end
    end

    context "existing page" do
      let!(:page) { create(:page, code: "page_one", name: "Page one") }
      let(:page_attr) { { code: "page_one", name: "Page one", parent_code: nil } }
      let(:visit) { build(:visit) }

      it "use existing page" do
        expect { visit.page_attributes=(page_attr) }.to change { Page.count }.by 0
      end
    end

    context "parent page exist" do
      let!(:page) { create(:page, code: "page_one", name: "Page one") }
      let(:page_attr) { { code: "page_two", name: "Page two", parent_code: page.code } }
      let(:visit) { build(:visit) }

      it "create a new page" do
        expect { visit.page_attributes=(page_attr) }.to change { Page.count }.by 1
      end
    end

    context "parent_id page not exist" do
      let(:page_attr) { { code: "page_two", name: "Page two", parent_code: "page_one" } }
      let(:visit) { build(:visit) }

      it "create 2 new pages" do
        expect { visit.page_attributes=(page_attr) }.to change { Page.count }.by 2
      end
    end
  end

  describe "platform_attributes=(attribute)" do
    context "new platform" do
      let(:platform_attr) { { name: "android" } }
      let(:visit) { build(:visit) }

      it "creates a new platform" do
        expect { visit.platform_attributes=(platform_attr) }.to change { Platform.count }.by 1
      end
    end

    context "existing platform" do
      let!(:platform) { create(:platform, name: "android") }
      let(:platform_attr) { { name: "android" } }
      let(:visit) { build(:visit) }

      it "uses existing platform" do
        expect { visit.platform_attributes=(platform_attr) }.to change { Platform.count }.by 0
      end
    end
  end

  describe "Callback #after_create" do
    let!(:app_user) { create(:app_user, registered_at: DateTime.yesterday) }
    let!(:visit) { create(:visit, visit_date: Time.zone.now, app_user:) }

    it "updates app_user last_accessed_at" do
      expect(app_user.reload.last_accessed_at).to eq(visit.visit_date)
    end
  end

  describe "#last_visit" do
    let!(:app_user) { create(:app_user, :anonymous) }
    let(:valid_params) { {
      app_user_id: app_user.id, visit_date: Time.now,
      page_attributes: { code: "page_one", name: "Page one", parent_code: nil },
      platform_attributes: { name: "android" }
    }}

    subject { described_class.new(valid_params) }

    context "first visit" do
      it "returns nil" do
        expect(subject.last_visit).to be_nil
      end
    end

    context "second visit with visit_date within 30mn" do
      let(:visit) { create(:visit, app_user:, page:, visit_date: (DateTime.now - 5.minute)) }

      context "on the same page" do
        let(:page) { create(:page, code: "page_one") }

        before {
          subject.visit_date = visit.visit_date + 5.minutes
        }

        it "returns 1 object" do
          expect(subject.last_visit).not_to be_nil
        end
      end

      context "different page" do
        let(:page) { create(:page, code: "page_zero") }

        before {
          subject.visit_date = visit.visit_date + 5.minutes
        }

        it "returns nil" do
          expect(subject.last_visit).to be_nil
        end
      end
    end

    context "second visit with visit_date >= 30mn" do
      let(:visit) { create(:visit, app_user:, page:, visit_date: (DateTime.now - 30.minute)) }

      context "on the same page" do
        let(:page) { create(:page, code: "page_one") }

        before {
          subject.visit_date = visit.visit_date + 31.minutes
        }

        it "returns nil" do
          expect(subject.last_visit).to be_nil
        end
      end

      context "different page" do
        let(:page) { create(:page, code: "page_zero") }

        before {
          subject.visit_date = visit.visit_date + 31.minutes
        }

        it "returns nil" do
          expect(subject.last_visit).to be_nil
        end
      end
    end
  end
end
