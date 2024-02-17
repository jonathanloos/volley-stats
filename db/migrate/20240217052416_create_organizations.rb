class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :title
      t.string :website
      t.references :user, null: false, foreign_key: true
      t.integer :category

      t.timestamps
    end

    add_reference :teams, :organization, null: true, foreign_key: true
    add_reference :users, :organization, null: true, foreign_key: true
  end
end
