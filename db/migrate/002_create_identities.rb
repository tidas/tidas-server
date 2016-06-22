migration 2, :create_identities do
  up do
    create_table :identities do
      column :id,           String, :length => 255
      column :pub_key,      String, :length => 1024
      column :customer_id,  Integer
      column :app_id,       Integer

      column :created_at,   Time
      column :last_seen,    Time
    end

    create_index :identities, :id
    create_index :identities, :customer_id
    create_index :identities, :app_id
  end

  down do
    drop_table :identities
  end
end
