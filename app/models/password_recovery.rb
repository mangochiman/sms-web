class PasswordRecovery < ActiveRecord::Base
  set_table_name :password_recoveries
  set_primary_key :password_recovery_id

  belongs_to :user, :foreign_key => :user_id
end
