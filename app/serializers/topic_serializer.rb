# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name         :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#
class TopicSerializer < ActiveModel::Serializer
  attributes :id, :name, :published_at, :service_ids, :audio

  has_many :questions

  def audio
    object.audio_url
  end

  class QuestionSerializer < ActiveModel::Serializer
    attributes :id, :code, :name, :type, :hint, :display_order, :audio, :topic_id

    has_many :options

    def audio
      object.audio_url
    end

    class OptionSerializer < ActiveModel::Serializer
      attributes :id, :name, :message, :move_next, :question_id
    end
  end
end
