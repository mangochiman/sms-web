class SmsController < ApplicationController
	def get_messages
		data = {}
		data[1] = {}
		data[1]["phone_number"] = "0999607901"
		data[1]["message"] = "Message 1"

		data[2] = {}
		data[2]["phone_number"] = "0999607901"
		data[2]["message"] = "Message 2"

		data[3] = {}
		data[3]["phone_number"] = "0999607901"
		data[3]["message"] = "Message 3"

		render :text => data.to_json
	end
end
