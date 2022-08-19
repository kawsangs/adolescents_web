class ApiKeysController < ApplicationController
  before_action :set_api_key, only: %i[ edit update archive]

  def index
    @pagy, @api_keys = pagy(authorize ApiKey.filter(filter_params))
  end

  def new
    @api_key = authorize ApiKey.new
  end

  def create
    @api_key = authorize ApiKey.new(api_key_params)

    respond_to do |format|
      if @api_key.save
        format.html { redirect_to api_keys_url, notice: "Api key was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @api_key.update(api_key_params)
        format.html { redirect_to api_keys_url, notice: "Api key was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def archive
    @api_key.destroy

    redirect_to api_keys_url, status: :see_other, notice: I18n.t("api_key.archive_successfully", name: @api_key.name)
  end

  def restore
    @api_key = authorize ApiKey.only_deleted.find(params[:id])
    @api_key.restore

    redirect_to api_keys_url, notice: I18n.t("api_key.restore_successfully", name: @api_key.name)
  end

  def destroy
    @api_key = authorize ApiKey.only_deleted.find(params[:id])
    @api_key.really_destroy!

    respond_to do |format|
      format.html { redirect_to api_keys_url(archived: true), notice: "Api key was successfully destroyed." }
      format.turbo_stream { redirect_to api_keys_url, status: :see_other, notice: "Api key was successfully destroyed." }
    end
  end

  private
    def api_key_params
      params.require(:api_key).permit(:name, :actived)
            .merge(user_id: current_user.id)
    end

    def filter_params
      params.permit(:name, :archived)
    end

    def set_api_key
      @api_key = authorize ApiKey.find(params[:id])
    end
end
