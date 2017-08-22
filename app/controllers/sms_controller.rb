class SmsController < ApplicationController
	def get_messages
		data = {}
		data[1] = {}
		data[1]["phone_number"] = "0999717377"
		data[1]["message"] = "Hie Mathews erererdsdsdsdsdsdsdsdsdsdsds"
=begin
		data[2] = {}
		data[2]["phone_number"] = "0884578430"
		data[2]["message"] = "Hie Blessings"

		data[3] = {}
		data[3]["phone_number"] = "0999607901"
		data[3]["message"] = "Hie Ernest"
=end
		render :text => data.to_json
	end
end
