class CreateTopicServices < ActiveRecord::Migration[7.0]
  def change
    create_table :topic_services, id: :uuid do |t|
      t.uuid :topic_id
      t.uuid :service_id

      t.timestamps
    end
  end
end
