# Message template follow: https://github.com/decision-labs/fcm

require "googleauth"

class PushNotificationService
  def initialize
    @success_count = 0
    @failure_count = 0
  end

  def notify(mobile_tokens, mobile_notification)
    mobile_tokens.each do |mobile_token|
      message = { 'token': mobile_token.token }.merge(mobile_notification.build_content)
      res = fcm.send_v1(message)

      if res[:status_code] == 200
        @success_count += 1
      else
        @failure_count += 1
        mobile_notification.mobile_notification_logs.create(mobile_token_id: mobile_token.id, failed_reason: res[:body])
      end
    end

    {
      success_count:  @success_count,
      failure_count: @failure_count
    }
  end

  private
    def fcm
      @fcm ||= FCM.new(
        access_token,
        credential_path,
        ENV["FIREBASE_PROJECT_ID"]
      )
    end

    def access_token
      @access_token ||= get_token
    end

    def credential_path
      @credential_path ||= Rails.root.join(ENV["GOOGLE_APPLICATION_CREDENTIALS_PATH"])
    end

    def get_token
      scope = "https://www.googleapis.com/auth/firebase.messaging"

      authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(credential_path),
        scope:)

      authorizer.fetch_access_token!["access_token"]
    end
end
