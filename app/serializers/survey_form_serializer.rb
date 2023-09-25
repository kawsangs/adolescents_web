class SurveyFormSerializer < ActiveModel::Serializer
  attributes :id, :code, :name_km, :name_en, :audio, :description

  has_many :sections

  def audio
    object.audio_url
  end
end
