module Samples
  class AppUser < Base
    def load(count = 1)
      count.times.each do |i|
        ::AppUser.create(
          gender: ::AppUser::GENDERS.sample,
          age: rand(10..20),
          province_id: format("%02d", rand(1..25)),
          device_id: "abc_#{rand(1..10)}",
          registered_at: rand(1.month).seconds.ago,
          occupation: ::AppUser.occupations.keys.sample,
          app_user_characteristics_attributes: app_user_characteristics.take(rand(1..3))
        )
      end
    end

    private
      def app_user_characteristics
        [
          { characteristic_attributes: { code: "PO" } },
          { characteristic_attributes: { code: "IP" } },
          { characteristic_attributes: { code: "DI" } }
        ]
      end
  end
end
