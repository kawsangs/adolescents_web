# == Schema Information
#
# Table name: reasons
#
#  id         :uuid             not null, primary key
#  code       :string
#  name_km    :string
#  name_en    :string
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ReasonSerializer < ActiveModel::Serializer
  attributes :id, :code, :name_km, :name_en, :deleted_at, :updated_at
end
