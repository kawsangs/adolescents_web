module Api
  module V1
    class CategoriesController < ApiController
      def index
        pagy, categories = pagy(Category.roots.includes(:children))

        render json: {
          pagy: pagy.vars,
          categories: ActiveModel::Serializer::CollectionSerializer.new(categories, serializer: CategorySerializer)
        }
      end

      def show
        category = Category.find(params[:id])

        render json: category
      end
    end
  end
end
