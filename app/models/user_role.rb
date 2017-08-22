class UserRole < ActiveRecord::Base
  set_table_name :user_role
  set_primary_key :user_role_id

  belongs_to :user, :foreign_key => :user_id
end
