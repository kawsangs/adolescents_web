namespace :app_user do
  desc "Remove user with 0 visits"
  task remove_zero_visits: :environment do
    AppUser.transaction do
      app_users = AppUser.where.not(id: Visit.pluck(:app_user_id).uniq)
      app_users.destroy_all
    end
  end

  desc "Set anonymous user to unknown location"
  task assign_anonymous_to_unknown_location: :environment do
    anonymouses = AppUser.where(age: -1)
    anonymouses.update_all(province_id: Location::UNKNOWN_PROVINCE_ID)
  end
end
