# frozen_string_literal: true

# == Schema Information
#
# Table name: batches
#
#  id             :uuid             not null, primary key
#  code           :string
#  total_count    :integer          default(0)
#  valid_count    :integer          default(0)
#  new_count      :integer          default(0)
#  province_count :integer          default(0)
#  reference      :string
#  creator_id     :integer
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Batches::VideoBatch < Batch
  def self.policy_class
    VideoBatchPolicy
  end
end
