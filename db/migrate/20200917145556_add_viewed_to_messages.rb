class AddViewedToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :viewed, :boolean, default: false
  end
end
