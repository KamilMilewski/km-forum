class CreateCategories < ActiveRecord::Migration[5.0] # :nodoc:
  def change
    create_table :categories do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
