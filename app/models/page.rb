# == Schema Information
#
# Table name: pages
#
#  id             :uuid             not null, primary key
#  code           :string
#  name           :string
#  parent_id      :uuid
#  lft            :integer          not null
#  rgt            :integer          not null
#  depth          :integer          default(0), not null
#  children_count :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Page < ApplicationRecord
  acts_as_nested_set

  has_many :visitors
end
