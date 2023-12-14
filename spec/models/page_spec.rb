# == Schema Information
#
# Table name: pages
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  parent_id      :uuid
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name_en        :string
#  name_km        :string
#  visits_count   :integer          default(0)
#  viz_code       :string
#
require "rails_helper"

RSpec.describe Page, type: :model do
  it { is_expected.to have_many(:visits) }
  it { is_expected.to validate_presence_of(:code) }

  describe "before_validation, #set_viz_code_and_name" do
    context "viz_code nil" do
      let(:page) { create(:page, code: "01", name: "Main", viz_code: nil) }

      it "assign viz_code with code value" do
        expect(page.viz_code).to eq(page.code)
      end
    end

    context "viz_code is not nil" do
      let(:page) { create(:page, code: "01", name: "Main", viz_code: "001") }

      it "assign viz_code to its own value" do
        expect(page.viz_code).to eq("001")
      end
    end
  end
end
