module Api
  module V1
    class VideosController < ApiController
      def index
        pagy, videos = pagy(Video.all)

        render json: { pagy: pagy.vars, videos: videos }
      end
    end
  end
end
