# frozen_string_literal: true

module V1
  class Error
    attr_accessor :title, :detail, :id, :href, :code, :source, :links, :status, :meta

    def initialize(options = {})
      @title          = options[:title]
      @detail         = options[:detail]
      @id             = options[:id]
      @href           = options[:href]
      @code           = options[:code]
      @source         = options[:source]
      @links          = options[:links]

      @status         = Rack::Utils::SYMBOL_TO_STATUS_CODE[options[:status]].to_s
      @meta           = options[:meta]
    end

    def as_json(_options = {})
      { title:, detail:, id:, href:, code:, source:, links:, status:, meta: }
    end
  end
end
