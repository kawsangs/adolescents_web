namespace :page do
  desc "migrate visits count"
  task migrate_visits_count: :environment do
    Page.find_each do |page|
      Page.reset_counters(page.id, :visits)
    end
  end

  desc "Migrate to set visualization code and name"
  task migrate_to_set_viz_code_and_name: :environment do
    Page.find_each do |page|
      page.update(viz_code: page.code)
    end
  end
end
