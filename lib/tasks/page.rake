namespace :page do
  desc "migrate visits count"
  task migrate_visits_count: :environment do
    Page.find_each do |page|
      Page.reset_counters(page.id, :visits)
    end
  end
end
