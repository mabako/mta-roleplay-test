class DefaultSettings < ActiveRecord::Migration
  class Setting < ActiveRecord::Base
  end

  def self.up
    Setting.create name: 'motd', value: 'Hello!'
    Setting.create name: 'amotd', value: 'Hello Mr. Admin!'
    Setting.create name: 'generalsupplies', value: '100000'
  end

  def self.down
    Setting.destroy_all
  end
end
