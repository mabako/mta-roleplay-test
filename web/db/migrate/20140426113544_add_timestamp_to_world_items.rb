class AddTimestampToWorldItems < ActiveRecord::Migration
  def change
    change_table :worlditems do |t|
      t.remove :creationdate
      t.timestamps
    end
  end
end
