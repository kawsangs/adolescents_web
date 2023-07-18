# frozen_string_literal: true

module Spreadsheets::AttachmentSpreadsheet
  def find_attachment(filename, zipfile)
    return unless filename.present?

    entry = zipfile.select { |ent| ent.name.split("/").last == "#{filename}" }.first

    open_file(entry, zipfile) if entry.present?
  end

  def open_file(entry, zipfile)
    file_destination = File.join("public/uploads/tmp", entry.name)

    FileUtils.mkdir_p(File.dirname(file_destination))
    zipfile.extract(entry, file_destination) { true }

    Pathname.new(file_destination).open
  end
end
