class TelegramBotsController < ApplicationController
  before_action :authorize_telegram_bot, on: [:show, :upsert]

  def show
  end

  def upsert
    if @telegram_bot.update(telegram_bot_params)
      redirect_to telegram_bot_path, flash: { notice: I18n.t("telegram_bot.update_successfully") }
    else
      render :show
    end
  end

  private
    def telegram_bot_params
      params.require(:telegram_bot).permit(
        :token, :username, :enabled
      )
    end

    def authorize_telegram_bot
      @telegram_bot = authorize TelegramBot.instance
    end
end
