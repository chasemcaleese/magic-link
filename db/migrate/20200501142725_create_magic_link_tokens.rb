class CreateMagicLinkTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :magic_link_tokens do |t|
      t.string :resource_id, :null => false
      t.string :token, :null => false 
      t.timestamp :token_sent_at, :null => false
      t.boolean :reusable, :default => false
      t.timestamps
    end
  end
end
