class ApiKey < ActiveRecord::Base
  set_table_name :api_keys
  set_primary_key :api_key_id

  belongs_to :user, :foreign_key => :user_id

  def self.new_api_key(user)
    api_key = ApiKey.new
    api_key.user_id = user.user_id
    api_key.expiry_date = (Date.today + 30.days)
    api_key.key = User.generate_api_key
    return api_key
  end

end
