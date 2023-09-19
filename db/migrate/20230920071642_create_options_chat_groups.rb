class CreateOptionsChatGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :options_chat_groups, id: :uuid do |t|
      t.uuid :option_id
      t.uuid :chat_group_id

      t.timestamps
    end
  end
end
