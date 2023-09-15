# frozen_string_literal: true

class Spreadsheets::Batches::BaseWithZipfileSpreadsheet
  attr_reader :batch, :user

  def initialize(user)
    @user = user
    @batch = batch_model.new
    @items = []
  end

  def import(file)
    return unless valid?(file)

    Zip::File.open(file) do |zipfile|
      entry = zipfile.select { |ent| ent.name.split(".").last == excel_format }.first

      return unless entry.present?

      spreadsheet(entry).each_with_pagename do |sheet_name, sheet|
        assign_items(sheet, sheet_name)
      rescue
        Rails.logger.warn "unknown handler for sheet: #{sheet_name}"
      end

      batch.importing_items = importing_items(zipfile)
      batch.attributes = batch.attributes.merge(batch_params(file))
      batch
    end
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

    def spreadsheet(entry)
      ::Zip::IOExtras.copy_stream(stream = StringIO.new, entry.get_input_stream)
      Roo::Spreadsheet.open(stream, extension: excel_format)
    end

    def valid?(file)
      file.present? && accepted_formats.include?(File.extname(file.path))
    end

    def accepted_formats
      [".zip"]
    end

    def excel_format
      "xlsx"
    end
end
