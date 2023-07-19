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

  desc "migrate facility_id to facility taggable"
  task migrate_facility_id_to_taggable: :environment do
    Tagging.where.not(facility_id: nil).each do |tagging|
      tagging.update(taggable_id: tagging.facility_id, taggable_type: "Facility")
    end
  end
end
