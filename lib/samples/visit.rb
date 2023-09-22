module Samples
  class Visit < Base
    def load(count = 1)
      count.times.each do |i|
        create_page_visit
        create_app_visit
      end
    end

    def simulate_visit_notification(count = 1)
      count.times.each do |i|
        pages = [
          { code: "open_remote_notification", name: "Open remote notification", parent_code: "" },
          { code: "open_in_app_notification", name: "Open in-app notification", parent_code: "" }
        ]

        click_on_page_detail(::MobileNotification.where(status: "delivered").where.not(topic_id: nil).all.sample, pages.sample)
      end
    end

    private
      def click_on_page_detail(pageable, page_attributes = {})
        ::Visit.create(
          app_user_id: ::AppUser.all.sample.id,
          visit_date: rand(1..100).days.ago,
          pageable:,
          page_attributes:
        )
      end

      def create_app_visit
        ::Visit.create(
          app_user_id: ::AppUser.all.sample.id,
          visit_date: rand(1.year).seconds.ago,
          page_attributes: { code: "app_visit", name: "App visit", parent_code: "" }
        )
      end

      def create_page_visit
        visit = ::Visit.new(
          app_user_id: ::AppUser.all.sample.id,
          visit_date: rand(1.year).seconds.ago,
          page_attributes: pages.sample.slice("code", "name", "parent_code").symbolize_keys
        )
        visit.pageable = Facility.all.sample if visit.page.code == "clinic_detail"
        visit.pageable = Video.all.sample if visit.page.code == "video_detail"
        visit.save
      end

      def pages
        @pages ||= get_root_pages
      end

      def get_root_pages
        data = JSON.parse(File.read(file_path("categories.json")))
        data.select { |d| d["parent_code"].nil? }
      end
  end
end
