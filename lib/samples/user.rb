# frozen_string_literal: true

module Samples
  class User < Base
    def self.load
      users = [
        { email: "admin@kawsang.com", role: :primary_admin }
      ]

      users.each do |user|
        u = ::User.new(user.merge({ password: "123456" }))
        u.confirm
      end
    end
  end
end
