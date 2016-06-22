migration 1, :create_customers do
  up do
    create_table :customers do
      column :id,                 Integer,  serial:     true
      column :name,               String,   length:     255
      column :email,              String,   length:     255
      column :api_key,            String,   length:     32
      column :encrypted_password, String,   allow_nil:  false,
                                            length:     60
      column :session_id,         String,   required:   false
      column :api_calls,          Integer

      column :is_verified,        DataMapper::Property::Boolean,
                                            default: false
    end
  end

  down do
    drop_table :customers
  end
end
