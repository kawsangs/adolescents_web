module Api
  module V1
    class ContactDirectoriesController < ApiController
      def index
        pagy, contact_directories = pagy(ContactDirectory.includes(:contacts))

        render json: {
          pagy: pagy.vars,
          contact_directories: ActiveModel::Serializer::CollectionSerializer.new(contact_directories, serializer: ContactDirectorySerializer)
        }
      end
    end
  end
end
