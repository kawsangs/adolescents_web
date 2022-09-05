module Samples
  class AppUser < Base
    def self.load(count = 1)
      count.times.each do |i|
        ::AppUser.create(
          gender: ::AppUser::GENDERS.sample,
          age: rand(10..20),
          province_id: format("%02d", rand(1..25)),
          device_id: "abc_#{rand(1..10)}",
          registered_at: rand(1.month).seconds.ago,
          app_user_characteristics_attributes: app_user_characteristics
        )
      end
    end

    def self.app_user_characteristics
      [
        { characteristic_attributes: { name: "Poor card" } },
        { characteristic_attributes: { name: "Minority" } },
        { characteristic_attributes: { name: "Disability" } }
      ]
    end
  end
end
