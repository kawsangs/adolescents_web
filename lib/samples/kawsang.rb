# frozen_string_literal: true

require_relative "sample"

module Samples
  class Kawsang
    def self.load_samples
      ::Samples::User.load
    end
  end
end
