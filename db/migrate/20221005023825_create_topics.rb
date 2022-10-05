class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics, id: :uuid do |t|
      t.string   :name
      t.integer  :version, default: 0
      t.datetime :published_at
      t.string   :audio

      t.timestamps
    end
  end
end
