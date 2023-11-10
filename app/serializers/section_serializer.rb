# == Schema Information
#
# Table name: sections
#
#  id            :uuid             not null, primary key
#  name          :string
#  topic_id      :uuid
#  display_order :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class SectionSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_order

  has_many :questions

  class QuestionSerializer < ActiveModel::Serializer
    attributes :id, :code, :name, :type, :hint, :audio_url, :display_order,
               :relevant, :required, :section_id

    has_many :options
    has_many :criterias

    class CriteriaSerializer < ActiveModel::Serializer
      attributes :id, :question_id, :question_code, :operator, :response_value
    end

    class OptionSerializer < ActiveModel::Serializer
      attributes :id, :name, :value, :question_id, :image_url

      def image_url
        return object.image_url if object.image.present?
      end
    end
  end
end
