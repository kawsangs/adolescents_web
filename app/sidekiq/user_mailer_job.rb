class UserMailerJob
  include Sidekiq::Job
  sidekiq_options queue: "high"

  def perform(user_id)
    user = User.find(user_id)
    user.send_otp_instructions_notification
  end
end
