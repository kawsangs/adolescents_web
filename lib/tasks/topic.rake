namespace :topic do
  desc "migrate name in English"
  task migrate_name_in_en: :environment do
    Topic.find_each do |topic|
      topic.update(name_en: "#{topic.name_km}(en)")
    end
  end
end
