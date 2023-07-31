class ContactsController < ApplicationController
  helper_method :filter_params
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html {
        @pagy, @contacts = pagy(query_contact)
      }

      format.json {
        @contacts = query_contact

        if @contacts.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to contacts_url
        else
          render json: @contacts
        end
      }

      format.xlsx {
        @contacts = query_contact

        if @contacts.length > Settings.max_download_record
          flash[:alert] = t("shared.file_size_is_too_big", max_record: Settings.max_download_record)
          redirect_to contacts_url
        else
          render xlsx: "index", filename: "contact_#{Time.new.strftime('%Y%m%d_%H_%M_%S')}.xlsx"
        end
      }
    end
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = authorize Contact.new(contact_params)

    if @contact.save
      redirect_to contacts_url, notice: "Contact was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to contacts_url, notice: "Contact was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy

    redirect_to contacts_url, notice: "Contact was successfully destroyed."
  end

  private
    def filter_params
      params.permit(:name)
    end

    def contact_params
      params.require(:contact).permit(
        :name, :value, :type,
        contact_directory_attributes: [:name]
      )
    end

    def set_contact
      @contact = authorize Contact.find(params[:id])
    end

    def query_contact
      authorize Contact.filter(filter_params).includes(:contact_directory)
    end
end
