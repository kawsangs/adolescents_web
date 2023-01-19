namespace :working_day do
  desc "migrate sunday index to 7"
  task migrate_sunday_index: :environment do
    WorkingDay.where(day: 0).update_all(day: 7)
  end
end
