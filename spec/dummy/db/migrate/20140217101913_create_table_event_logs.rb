class CreateTableEventLogs < ActiveRecord::Migration
  def self.up
    create_table :event_logs, force: true do |t|
      t.string   :event_type
      t.integer  :item_id
      t.integer  :user_id
      t.text     :logged_changes
      t.datetime :created_at
    end

    add_index :event_logs, :item_id
    add_index :event_logs, :user_id
    add_index :event_logs, :created_at
  end

  def self.down
    drop_table :event_logs
  end
end
