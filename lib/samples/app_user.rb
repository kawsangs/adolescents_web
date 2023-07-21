module Samples
  class AppUser < Base
    def load(count = 1)
      count.times.each do |i|
        create_user
      end
    end

    private
      def create_user
        user = ::AppUser.new(
          gender: ::AppUser::GENDERS.sample,
          age: rand(10..30),
          province_id: format("%02d", rand(1..25)),
          device_id: "abc_#{rand(1..10)}",
          registered_at: rand(1.month).seconds.ago,
          occupation: ::AppUser.occupations.keys.sample,
          app_user_characteristics_attributes: app_user_characteristics.take(rand(1..3))
        )

        user.education_level = get_education_level(user)
        user.save
      end

      def get_education_level(user)
        return 'n_a' if user.n_a?

        user.student? ? student_education_levels.sample : ::AppUser.education_levels.keys.sample
      end

      def student_education_levels
        ['general_knowledge', 'university', 'tvet']
      end

      def app_user_characteristics
        [
          { characteristic_attributes: { code: "PO" } },
          { characteristic_attributes: { code: "IP" } },
          { characteristic_attributes: { code: "DI" } }
        ]
      end
  end
end
