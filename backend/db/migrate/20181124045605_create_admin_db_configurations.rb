class CreateAdminDbConfigurations < ActiveRecord::Migration[5.2]
  using(:master_db, :frankfurt)
  def change
    create_table :admin_db_configurations do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
