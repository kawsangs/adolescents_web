# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name_km      :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  name_en      :string
#  type         :string
#  description  :text
#
require "rails_helper"

RSpec.describe Topic, type: :model do
  it { is_expected.to have_many(:questions) }

  it { is_expected.to validate_presence_of(:name_en) }
  it { is_expected.to validate_presence_of(:name_km) }

  describe "nested attributes" do
    let!(:survey_form) { create(:topic, sections_attributes: [ { name: "section 1" } ]) }
    let(:section) { survey_form.sections.first }

    it "updates section name" do
      survey_form.update(sections_attributes: [ { id: section.id, name: "test" }])

      expect(section.reload.name).to eq("test")
    end
  end
end
