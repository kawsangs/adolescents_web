class SessionsController < Devise::SessionsController
  append_before_action :assert_otp_token_passed, only: :verify_otp

  # GET /sign_in/new
  def new
    self.resource = resource_class.new
  end

  # POST /sign_in
  def create
    self.resource = resource_class.send_otp_instructions(resource_params)

    if successfully_sent?(resource)
      @resource = resource_class.new(email: resource.email)
      set_flash_message(:notice, :send_instructions)

      render :show
    else
      render :new
    end
  end

  # GET /verify_otp
  def show
    redirect_to new_session_path(resource_name)
  end

  # POST /verify_otp
  def verify_otp
    self.resource = resource_class.find_otp_by_token(param_token)

    if resource.errors.empty?
      set_sign_in_type
      set_flash_message(:notice, :signed_in)
      sign_in(resource_name, resource)

      redirect_to :root
    else
      remove_notice
      @resource = resource_class.new(param_email)
      render :show
    end
  end

  protected
    # Check if a reset_password_token is provided in the request
    def assert_otp_token_passed
      return unless param_token.blank?

      set_flash_message(:alert, :no_token)
      redirect_to new_session_path(resource_name)
    end

    def param_token
      params.require(:user).permit(:otp_token)
    end

    def param_email
      params.require(:user).permit(:email)
    end

    def remove_notice
      flash[:notice] = nil
      flash[:alert] = nil
    end

    def set_sign_in_type
      resource.update_column(:sign_in_type, User::SYSTEM)
    end
end
