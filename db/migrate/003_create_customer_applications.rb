migration 3, :create_customer_applications do
  up do
    create_table :customer_applications do
      column :id,           Integer, :serial => true
      column :customer_id,  Integer
      column :name,         String, :length => 255
    end

    create_index :customer_applications, :customer_id
  end

  down do
    drop_table :customer_applications
  end
end
