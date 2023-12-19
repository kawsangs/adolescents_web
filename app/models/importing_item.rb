# == Schema Information
#
# Table name: importing_items
#
#  id            :uuid             not null, primary key
#  itemable_id   :uuid
#  itemable_type :string
#  batch_id      :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ImportingItem < ApplicationRecord
  # Association
  belongs_to :itemable, polymorphic: true, autosave: true
  belongs_to :batch

  def itemable_attributes=(attributes)
    self.itemable ||= itemable_type.constantize.new
    self.itemable.assign_attributes(attributes)
    self.itemable.save if self.itemable.persisted?
  end
end
