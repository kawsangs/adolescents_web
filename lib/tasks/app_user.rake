namespace :app_user do
  desc "Remove user with 0 visits"
  task remove_zero_visits: :environment do
    AppUser.transaction do
      app_users = AppUser.where.not(id: Visit.pluck(:app_user_id).uniq)
      app_users.destroy_all
    end
  end
end
