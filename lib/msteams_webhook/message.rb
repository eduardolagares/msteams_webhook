# require 'httpclient'
require "active_support"
require "active_support/core_ext"

class MsteamsWebhook::Message
	def initialize(text, title=nil)
		@text = text
		@title = title
	end

    def as_json
		msg = {}
		msg[:summary] = @summary if @summary
		msg[:title] = @title if @title
		msg[:text] = @text if @text
		msg[:themeColor] = @color if @color

		msg[:sections] = @sections if @sections
        msg[:potentialAction] = @potential_action if @potential_action
        
        msg
	end

    def to_json
        as_json.to_json
	end

	def set_color(color)
		@color = color
	end

	def add_activity(text,title=nil,image=nil)
		activity = {}
		activity[:activityTitle] = title if title
		activity[:activityText] = text if text
		activity[:activityImage] = image if image

		@sections = [] unless @sections
		@sections << activity
	end

	def add_facts(title,array)
		section = {}
		section[:title] = title if title
		section[:facts] = []
		array.each { |name,value| section[:facts] << { :name => name, :value => value } }

		@sections = [] unless @sections
		@sections << section
	end

	def add_image(title,image)
		add_images(title,[image])
	end

	def add_images(title,images)
		section = {}
		section[:title] = title
		section[:images] = []
		images.each { |image| section[:images] << { :image => image } }

		@sections = [] unless @sections
		@sections << section	
	end

	def add_action(text,url)
		@potential_action = [] unless @potential_action
		@potential_action << {
			:@context => 'http://schema.org',
			:@type => 'ViewAction',
			:name => text,
			:target => [url]
		}
	end

    def send(url=nil, async=false)
        url = url || MsteamsWebhook::default_url
		begin
			client = HTTPClient.new
			client.ssl_config.cert_store.set_default_paths
			client.ssl_config.ssl_version = :auto
			if async
				client.post_async url, getJson
			else
				client.post url, getJson
			end
		rescue Exception => e
			Rails.logger.warn("cannot connect to #{url}")
			Rails.logger.warn(e)
		end
	end
end