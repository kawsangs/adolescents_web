# frozen_string_literal: true

module Spreadsheets
  module Batches
    class ContactSpreadsheet
      attr_reader :contact

      def initialize(contact)
        @contact = contact
      end

      def process(row)
        contact.attributes = {
          name: row["name"],
          value: row["value"],
          channel: row["channel"],
          type: "Contacts::#{row['channel'].to_s.titleize}",
          contact_directory_attributes: { name: row["category"] }
        }

        contact
      end
    end
  end
end
