module Api
  module V1
    class MobileTokensController < ApiController
      def create
        @token = MobileToken.find_or_initialize_by(device_id: token_params["device_id"])

        if @token.update(token_params)
          render json: @token
        else
          render json: @token.errors, status: :unprocessable_entity
        end
      end

      private
        def token_params
          params.require(:mobile_token).permit(
            :token, :device_id, :device_type, :app_version, :platform, :device_os
          )
        end
    end
  end
end
