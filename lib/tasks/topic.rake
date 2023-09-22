namespace :topic do
  desc "migrate name in English"
  task migrate_name_in_en: :environment do
    Topic.find_each do |topic|
      topic.update(name_en: "#{topic.name_km}(en)")
    end
  end

  desc "migrate existing topic type to faq form"
  task migrate_top_faq_form_type: :environment do
    topics = Topic.where(type: nil)
    topics.update_all(type: "Topics::FaqForm")
  end
end
