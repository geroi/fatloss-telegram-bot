class AddInformToClients < ActiveRecord::Migration
  def change
    add_column :clients, :inform, :boolean, default: false
  end
end