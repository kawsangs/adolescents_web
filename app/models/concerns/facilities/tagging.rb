module Facilities::Tagging
  extend ActiveSupport::Concern

  included do
    attr_accessor :tag_list

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    def self.tagged_with(name)
      Tag.find_by_name!(name).articles
    end

    def self.tag_counts
      Tag.select("tags.*, count(taggings.tag_id) as count").
        joins(:taggings).group("tags.id")
    end

    def tag_list
      tags.map(&:name).join(", ")
    end

    def tag_list=(names)
      self.tags = names.to_s.split(",").map do |n|
        Tag.where(name: n.strip).first_or_create!
      end
    end
  end
end
