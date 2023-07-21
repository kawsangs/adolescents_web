# frozen_string_literal: true

class Spreadsheets::Batches::BaseSpreadsheet
  attr_reader :batch

  def initialize
    @batch = batch_model.new
    @items = []
  end

  def import(file)
    return unless valid?(file)

    spreadsheet(file).each_with_pagename do |sheet_name, sheet|
      assign_items(sheet, sheet_name)
    rescue
      Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
    end

    batch.importing_items = importing_items
    batch.attributes = batch.attributes.merge(batch_params(file))
    batch
  end

  private
    def batch_model
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    def importing_items
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    def assign_items(sheet, sheet_name)
      @items = sheet.parse(headers: true)[1..-1]
    end

    def batch_params(file)
      items = batch.importing_items.map(&:itemable)
      {
        total_count: items.length,
        valid_count: items.select(&:valid?).length,
        new_count: items.select(&:new_record?).length,
        reference: file
      }
    end

    def spreadsheet(file)
      Roo::Spreadsheet.open(file)
    end

    def valid?(file)
      file.present? && accepted_formats.include?(File.extname(file.path))
    end

    def accepted_formats
      [".xlsx"]
    end

    def parse_string(data)
      data.to_s.strip
    end

    def parse_date(date)
      DateTime.parse(parse_string(date)) rescue nil
    end
end
