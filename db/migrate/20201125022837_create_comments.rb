class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :commenter_id
      t.string :song_id

      t.timestamps
    end
  end
end
