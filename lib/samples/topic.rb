require_relative "topics/topic"
require_relative "topics/question"
require_relative "topics/option"

module Samples
  class Topic < Base
    def load
      path = file_path("topics.xlsx")
      xlsx = Roo::Spreadsheet.open(path)
      xlsx.each_with_pagename do |page_name, sheet|
        rows = sheet.parse(headers: true)
        klass = "::Samples::Topics::#{page_name.camelcase}"
        klass.constantize.new.load(rows)
      rescue
        Rails.logger.warn "#{klass} is unknown!"
      end
    end
  end
end
