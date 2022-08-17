# frozen_string_literal: true

require_relative "sample"

module Samples
  class Kawsang
    def self.load_samples
      ::Samples::User.load
      ::Samples::Visit.load
    end
  end
end
