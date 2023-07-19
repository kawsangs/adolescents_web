# frozen_string_literal: true

require_relative "sample"

module Samples
  class Kawsang
    def load_samples
      load_references
      ::Samples::AppUser.new.load
      ::Samples::Visit.new.load
      ::Samples::Topic.new.load
      ::Samples::Quiz.new.load
    end

    def load_references
      ::Samples::Location.new.load
      ::Samples::Characteristic.new.load
      ::Samples::User.new.load
      ::Samples::Category.new.load

      create_batch("CategoryBatch", "categories.zip")
    end

    private
      def create_batch(model_name, filename)
        klass = "::Spreadsheets::Batches::#{model_name}Spreadsheet".constantize
        batch = klass.new.import(file(filename))
        batch.creator = creator
        batch.save

        puts "Loaded #{model_name} samples"
      rescue
        Rails.logger.warn "unknown handler for class: #{klass}"
      end

      def file(filename)
        File.open(Pathname.new(File.join(Rails.root, "public", "sample", filename)))
      end

      def creator
        @creator ||= ::User.primary_admin.first
      end
  end
end
