# == Schema Information
#
# Table name: services
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at
end
