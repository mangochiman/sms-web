require 'rest_client'
class Contact < ActiveRecord::Base
  set_table_name :contacts
  set_primary_key :contact_id

  def self.send_email(params)
    uri = "http://71.19.148.67:5000//send_email"
    RestClient.post(uri,params)
  end
  
end
