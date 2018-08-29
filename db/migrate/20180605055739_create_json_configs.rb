class CreateJsonConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :orbital_configs do |t|
      t.string :uid
      t.integer :version
      t.text :data
    end
    add_index :orbital_configs, [:uid, :version], unique: true
  end
end
