module Users::OtpConcern
  extend ActiveSupport::Concern

  included do
    OTP_LENGTH = 6

    def send_otp_instructions
      token = set_otp_token
      send_otp_instructions_notification(token)
      token
    end

    def set_otp_token
      token = secure_token

      self.otp_token = token
      self.otp_sent_at = Time.now.utc

      save(validate: false)
      token
    end

    def secure_token
      token = SecureRandom.random_number(10**OTP_LENGTH).to_s.rjust(OTP_LENGTH, "0")
      return token unless self.class.exists?(otp_token: token)
      secure_token
    end

    def send_otp_instructions_notification(token)
      UserMailer.otp_instructions(self, token).deliver_now
    end

    def otp_period_valid?
      otp_sent_at && otp_sent_at.utc >= self.class.otp_within.ago.utc
    end

    class << self
      def otp_keys
        [:email]
      end

      def otp_within
        5.minutes
      end

      def send_otp_instructions(attributes = {})
        recoverable = find_or_initialize_with_errors(otp_keys, attributes, :not_found)
        recoverable.send_otp_instructions if recoverable.persisted?
        recoverable
      end

      def find_otp_by_token(attributes = {})
        original_token = attributes[:otp_token]
        recoverable = find_or_initialize_with_error_by(:otp_token, original_token)
        recoverable.errors.add(:otp_token, :expired) if recoverable.persisted? && !recoverable.otp_period_valid?
        recoverable.otp_token = original_token if recoverable.otp_token.present?
        recoverable
      end
    end
  end
end
