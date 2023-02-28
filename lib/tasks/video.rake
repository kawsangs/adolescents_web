namespace :video do
  desc "migrate video author"
  task migrate_video_author: :environment do
    authors = Video.pluck(:author).uniq
    authors.each do |name|
      author = VideoAuthor.find_or_create_by(name:)

      Video.where(author: name).update_all(video_author_id: author.id)
    end
  end

  desc "migrate videos count"
  task migrate_videos_count: :environment do
    VideoAuthor.find_each do |author|
      VideoAuthor.reset_counters(author.id, :videos)
    end
  end

  desc "migrate display order"
  task migrate_display_order: :environment do
    VideoAuthor.order(:created_at).find_each.with_index do |author, index|
      author.update(display_order: index + 1)
    end
  end
end
