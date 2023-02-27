class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  strip_attributes

  def self.update_order!(ids)
    ids.each_with_index do |id, index|
      self.update(id, display_order: index + 1)
    end
  end

  private
    def secure_code
      self.code ||= SecureRandom.uuid[0..5]

      return unless self.class.exists?(code:)

      self.code = SecureRandom.uuid[0..5]
      secure_code
    end
end
