# frozen_string_literal: true

class Spreadsheets::Base
  def import(file_path)
    return unless valid?(file_path)

    spreadsheet(file_path).each_with_pagename do |sheet_name, sheet|
      rows = sheet.parse(headers: true)
      rows[1..-1].each do |row|
        process(row)
      end
    rescue
      Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
    end
  end

  def process(row)
    raise "Implement in sub class"
  end

  private
    def spreadsheet(file_path)
      Roo::Spreadsheet.open(file_path)
    end

    def valid?(file_path)
      file_path.present? && accepted_formats.include?(File.extname(file_path))
    end

    def accepted_formats
      [".xls", ".xlsx"]
    end

    def parse_string(data)
      data.to_s.strip
    end

    def parse_date(date)
      DateTime.parse(parse_string(date)) rescue nil
    end

    def string_to_array(str)
      str.to_s.split(",").map { |st| st.strip }
    end
end
