# == Schema Information
#
# Table name: contact_directories
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ContactDirectorySerializer < ActiveModel::Serializer
  attributes :id, :name, :updated_at

  has_many :contacts
end
