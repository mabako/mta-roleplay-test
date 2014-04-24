class AddTimestampsToCharacters < ActiveRecord::Migration
  def change
  	change_table :characters do |t|
      t.remove :creationdate
      t.timestamps
  	end
  end
end
