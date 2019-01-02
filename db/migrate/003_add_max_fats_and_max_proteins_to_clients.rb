class AddMaxFatsAndMaxProteinsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :max_fats, :integer
    add_column :clients, :max_proteins, :integer  
  end
end