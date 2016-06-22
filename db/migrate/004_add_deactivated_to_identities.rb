migration 4, :add_deactivated_to_identities do
  up do
    modify_table :identities do
      add_column :deactivated, DataMapper::Property::Boolean, default: false
    end
  end

  down do
    modify_table :identities do
      drop_column :deactivated
    end
  end
end
