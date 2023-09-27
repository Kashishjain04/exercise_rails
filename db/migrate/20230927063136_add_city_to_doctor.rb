class AddCityToDoctor < ActiveRecord::Migration[7.0]
  def change
    add_column :doctors, :city, :string, null: false, default: "NA"
  end
end
