module GroupLoanWeeklyCollectionReportsHelper
	def pdf_image_tag(filename, options = {})
	   path = Rails.root.join("app/assets/images/#{filename}")
	   options[:src] = path.to_s
	   attributes = options.map{ |k,v| "#{k}='#{v}'" }.join(" ")
	   raw("&lt;img #{attributes} /&gt;")
	 end
end
