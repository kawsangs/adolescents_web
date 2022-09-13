class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  strip_attributes

  private
    def secure_code
      self.code ||= SecureRandom.uuid[0..5]

      return unless self.class.exists?(code:)

      self.code = SecureRandom.uuid[0..5]
      secure_code
    end
end
