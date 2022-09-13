# frozen_string_literal: true

require_relative "sample"

module Samples
  class Kawsang
    def self.load_samples
      ::Samples::Characteristic.new.load
      ::Samples::User.new.load
      ::Samples::AppUser.new.load
      ::Samples::Visit.new.load
    end

    def self.load_references
      ::Samples::Characteristic.new.load
      ::Samples::User.new.load
    end
  end
end
