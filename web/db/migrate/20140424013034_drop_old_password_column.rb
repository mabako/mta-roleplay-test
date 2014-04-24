class DropOldPasswordColumn < ActiveRecord::Migration
  def self.up
    change_table :accounts do |t|
      t.remove :password
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
