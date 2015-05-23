require 'httparty'
require 'json'

class GroupLoanWeeklyCollectionReport < ActiveRecord::Base
	validates_uniqueness_of :server_id

	def self.create_object(params)
		new_object = self.new
		new_object.server_id = params[:server_id]
		new_object.confirmed_at = params[:confirmed_at]
		new_object.save 

		return new_object
	end

	def mark_as_printed 
		self.print_date = DateTime.now 
		self.is_printed = true 
		self.save 
	end

	def self.get_auth_token
		response = HTTParty.post( "http://neo-sikki.herokuapp.com/api2/users/sign_in" ,
		  { 
		    :body => {
		    	:user_login => { :email =>EMAIL, :password => PASSWORD }
		    }
		  })

		server_response =  JSON.parse(response.body )
		server_response["auth_token"]
	end

	def extract_details_from_server
		auth_token  = self.class.get_auth_token 

		response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/group_loan_weekly_collection_reports/#{self.server_id}" ,
		  :query => {
		  	:auth_token => auth_token
		  })

		server_response =  JSON.parse(response.body )
		result_array = []

		server_response["group_loan_weekly_collection_report_details"]  
	end

	def self.extract_from_server( )
		
		auth_token  =  self.get_auth_token 
		response = HTTParty.get( "http://neo-sikki.herokuapp.com/api2/group_loan_weekly_collection_reports" ,
		  :query => {
		  	:page => 1,
		  	:limit => 30,
		  	:auth_token => auth_token
		  })

		server_response =  JSON.parse(response.body )

		server_response["group_loan_weekly_collection_reports"].each do |glwc|
			self.create_object(
					:server_id => glwc["id"],
					:confirmed_at => glwc["confirmed_at"],
					:collected_at => glwc["collected_at"]
					# :confirmed_at => glwc["confirmed_at"]
				)
		end
	end
end
