class AddTrackingToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :tracking, :boolean, default: false
    add_column :questions, :required, :boolean, default: false
    add_column :questions, :relevant, :string
    add_column :questions, :section_id, :uuid
  end
end
