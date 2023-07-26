module Api
  module V1
    class ContactsController < ApiController
      def index
        pagy, contacts = pagy(Contact.includes(:contact_directory))

        render json: {
          pagy: pagy.vars,
          contacts: ActiveModel::Serializer::CollectionSerializer.new(contacts, serializer: ContactSerializer)
        }
      end
    end
  end
end
