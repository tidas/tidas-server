migration 6, :drop_access_logs do
  up do
    drop_table :access_logs
  end

  down do
    create_table :access_logs do
      column :id,           Integer,  :serial => true
      column :action,       String
      column :ip,           String
      column :tidas_id,     String
      column :success,      DataMapper::Property::Boolean
      column :created_at,   Time

      column :app_id,       Integer
      column :customer_id,  Integer
    end

    create_index :access_logs,  :tidas_id
    create_index :access_logs,  :app_id
    create_index :access_logs,  :customer_id
  end
end
