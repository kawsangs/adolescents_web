module Api
  module V1
    class VideosController < ApiController
      def index
        @videos = Video.all

        render json: @videos
      end
    end
  end
end
