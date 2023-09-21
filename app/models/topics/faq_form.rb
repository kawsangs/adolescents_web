# == Schema Information
#
# Table name: topics
#
#  id           :uuid             not null, primary key
#  name_km      :string
#  version      :integer          default(0)
#  published_at :datetime
#  audio        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  code         :string
#  name_en      :string
#  type         :string
#  description  :text
#
module Topics
  class FaqForm < ::Topic
    def self.policy_class
      FaqFormPolicy
    end
  end
end
