namespace :profile do
  desc "Update minority to indigenous people"
  task update_minority_to_indigenous_people: :environment do
    characteristic = Characteristic.find_by(code: "MI")
    characteristic.update(code: "IP", name_en: "Indigenous people", name_km: "ជនជាតិដើមភាគតិច")
  end
end
