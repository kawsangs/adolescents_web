# == Schema Information
#
# Table name: contacts
#
#  id                   :uuid             not null, primary key
#  name                 :string
#  value                :string
#  type                 :string
#  contact_directory_id :uuid
#  display_order        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :value, :type, :display_order, :updated_at

  belongs_to :contact_directory
end