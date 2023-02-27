namespace :tag do
  desc "migrate taggings count"
  task migrate_taggings_count: :environment do
    Tag.find_each do |tag|
      Tag.reset_counters(tag.id, :taggings)
    end
  end

  desc "migrate display order"
  task migrate_display_order: :environment do
    Tag.order(:created_at).find_each.with_index do |tag, index|
      tag.update(display_order: index + 1)
    end
  end
end
