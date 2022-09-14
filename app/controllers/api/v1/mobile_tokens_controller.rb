module Api
  module V1
    class MobileTokensController < ApiController
      def update
        @token = MobileToken.find_or_initialize_by(id: token_params["id"])

        if @token.update(token_params)
          render json: @token
        else
          render json: @token.errors, status: :unprocessable_entity
        end
      end

      private
        def token_params
          params.require(:mobile_token).permit(
            :id, :token, :device_id, :device_type, :app_version
          )
        end
    end
  end
end
