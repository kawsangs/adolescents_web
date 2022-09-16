module Samples
  class Visit < Base
    def load(count = 1)
      count.times.each do |i|
        visit = ::Visit.new(
          app_user_id: ::AppUser.all.sample.id,
          visit_date: rand(1.year).seconds.ago,
          page_attributes: pages.sample,
          platform_attributes: platforms.sample
        )
        visit.pageable = Facility.all.sample if visit.page.code == "clinic_detail"
        visit.pageable = Video.all.sample if visit.page.code == "video_detail"
        visit.save
      end
    end

    private
      def pages
        [
          { code: "page_one", name: "Page 1", parent_code: "" },
          { code: "page_one_one", name: "Page 1.1", parent_code: "page_one" },
          { code: "page_two", name: "Page 2", parent_code: "" },
          { code: "page_two_one", name: "Page 2.1", parent_code: "page_two" },
          { code: "page_three", name: "Page 3", parent_code: "" },
          { code: "page_three_one", name: "Page 3.1", parent_code: "page_three" },
          { code: "page_four", name: "Page 4", parent_code: "" },
          { code: "page_four_one", name: "Page 4.1", parent_code: "page_four" },
          { code: "page_five", name: "Page 5", parent_code: "" },
          { code: "page_five_one", name: "Page 5.1", parent_code: "page_five" },
          { code: "page_six", name: "Page 6", parent_code: "" },
          { code: "page_six_one", name: "Page 6.1", parent_code: "page_six" },
          { code: "clinic", name: "Clinic", parent_code: "" },
          { code: "clinic_detail", name: "Clinic detail", parent_code: "clinic" },
          { code: "video", name: "Video", parent_code: "" },
          { code: "video_detail", name: "Video detail", parent_code: "video" }
        ]
      end

      def platforms
        [
          { name: "android" },
          { name: "ios" },
          { name: "web" }
        ]
      end
  end
end
