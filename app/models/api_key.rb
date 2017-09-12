class ApiKey < ActiveRecord::Base
  set_table_name :api_keys
  set_primary_key :api_key_id

  belongs_to :user, :foreign_key => :user_id
end
