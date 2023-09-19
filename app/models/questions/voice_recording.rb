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
  class VoiceRecording < Question
    def icon
      "<i class=\'fa-solid fa-microphone icon\'></i>"
    end

    def label
      "Voice Recording"
    end
  end
end
