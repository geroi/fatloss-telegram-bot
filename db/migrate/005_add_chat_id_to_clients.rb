class AddChatIdToClients < ActiveRecord::Migration
  def change
    add_column :clients, :chat_id, :integer
  end
end