module ItemableConcern
  extend ActiveSupport::Concern

  included do
    has_many :importing_items, as: :itemable
    has_many :batches, through: :importing_items
  end
end
