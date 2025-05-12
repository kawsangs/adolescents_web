# Message template follow: https://github.com/decision-labs/fcm

require "googleauth"

class PushNotificationService
  attr_reader :detail, :success_count, :failure_count, :mobile_notification

  def initialize(mobile_notification)
    @success_count = 0
    @failure_count = 0
    @detail = {
      success: { ios: 0, android: 0 },
      failure: { ios: 0, android: 0 }
    }

    @mobile_notification = mobile_notification
  end

  def notify_all(mobile_tokens)
    mobile_tokens.find_each do |mobile_token|
      notify(mobile_token)
    end

    { detail:, success_count:, failure_count: }
  end

  def notify(mobile_token)
    res = fcm.send_v1(build_message(mobile_token))

    if res[:status_code] == 200
      handle_success(res, mobile_token)
    else
      handle_failure(res, mobile_token)
    end
  end

  private
    def build_message(mobile_token)
      { 'token': mobile_token.token }.merge(mobile_notification.build_content)
    end

    def handle_success(res, mobile_token)
      @success_count += 1
      @detail[:success][mobile_token.platform.to_sym] += 1
    end

    def handle_failure(res, mobile_token)
      @failure_count += 1
      @detail[:failure][mobile_token.platform.to_sym] += 1

      mobile_notification.mobile_notification_logs.create(mobile_token_id: mobile_token.id, failed_reason: res[:body])
      mobile_token.update(active: false) if inactive_token_status_codes.include?(res[:status_code].to_s)
    end

    def inactive_token_status_codes
      [
        "400", # Bad request, token: is invalid format - ex: token: "BLACKLISTED"
        "403", # The FCM token belongs to a different Firebase project
        "404", # The device token does not exist or the app is uninstall
      ]
    end

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
