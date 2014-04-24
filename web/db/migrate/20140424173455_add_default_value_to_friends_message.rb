class AddDefaultValueToFriendsMessage < ActiveRecord::Migration
  def change
    change_table :accounts do |t|
      t.remove :friendsmessage
      t.string :friendsmessage, default: 'Hey!', null: false
    end
  end
end
