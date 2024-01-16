# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def otp_instructions(user, token)
    @user = user
    @token = token

    mail(to: user.email, subject: "#{ENV['APP_NAME']} - One time sign in")
  end
end
