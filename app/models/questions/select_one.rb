# == Schema Information
#
# Table name: questions
#
#  id            :uuid             not null, primary key
#  code          :string
#  name          :text
#  type          :string
#  hint          :string
#  display_order :integer
#  audio         :string
#  topic_id      :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  answer        :text
#  tracking      :boolean          default(FALSE)
#  required      :boolean          default(FALSE)
#  relevant      :string
#  section_id    :uuid
#
module Questions
  class SelectOne < Question
    def icon
      "<i class=\'far fa-dot-circle icon\'></i>"
    end

    def label
      "Select One"
    end
  end
end
