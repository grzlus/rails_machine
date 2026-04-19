ActiveRecord::Schema.define(version: 1) do
  create_table :vehicles, force: true do |t|
    t.string :make
    t.string :model
    t.integer :state, default: 0
    t.boolean :inspected, default: false
    t.timestamps
  end
end

