class CreateAppUserReasons < ActiveRecord::Migration[7.0]
  def change
    create_table :app_user_reasons do |t|
      t.uuid :app_user_id
      t.string :reason_code

      t.timestamps
    end
  end
end
