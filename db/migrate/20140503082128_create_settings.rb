class CreateSettings < ActiveRecord::Migration
  def up
    create_table :settings do |t|
      t.string :name, :limit => 255, :default => '', :null => false, :presence => true
      t.string :value
      t.datetime :updated_on
      t.timestamps 
    end
    add_index :settings, :name
  end

  def down
    drop table :settings
  end

end
