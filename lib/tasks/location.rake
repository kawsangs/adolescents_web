namespace :location do
  desc "Upsert unknown province"
  task upsert_unknown_province: :environment do
    location = Location.find_or_initialize_by(id: Location::UNKNOWN_PROVINCE_ID)
    location.update(
      name_en: "Unknown (anonymous)",
      name_km: "មិនមាន (អនាមិក)",
      kind: "province",
      latitude: 11.627817900613811,
      longitude: 102.21644822124985
    )
  end
end
