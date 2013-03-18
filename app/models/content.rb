require 'regex';

class Content < ActiveRecord::Base
	include SocialInteraction;
	include ActionView::Helpers::TagHelper;
	
	self.abstract_class = true;
	
	# relationships
	belongs_to :user
	
	has_many :content_mentions;
	has_many :content_hashtags;
	has_many :mentions, { :through => :content_mentions, :source => :user, :as => :content };
	has_many :hashtags, { :through => :content_hashtags, :as => :content };
	
	# available columns (in the abstract)
	attr_accessible :text_body, :date_created;
	
	# database hooks
	around_save :around_save_hook
	
	# parsing
	ENTITY_PATTERN = /
		(?: # hashtag 
			(?<boundary>#{Regex::HASHTAG_BOUNDARY})
			(?<token>\#) 
			(?<value>#{Regex::HASHTAG_ALPHANUMERIC}{2,30})
		) | (?: #mention
			(?<boundary>#{Regex[:valid_mention_preceding_chars]})
			(?<token>@)
			(?<value>[a-zA-Z0-9_]{1,20})
		)
	/iox;
	
	def render_html()
		handles = []
		tags = []
		
		mentions.select('users.name').each {|r| handles << r.name.downcase()};
		hashtags.select('hashtags.tag').each {|r| tags << r.tag.downcase()};
		
		return text_body.gsub(ENTITY_PATTERN) do |match|
			m = $~;
			if m[:token] == '@'
				m[:boundary] + (handles.include?(m[:value].downcase()) ? content_tag('a', "@#{m[:value]}", { :href => "/#{m[:value]}", :title => m[:value] }) : "@#{m[:value]}");
			else
				m[:boundary] + (tags.include?(m[:value].downcase()) ?  content_tag('a', "##{m[:value]}", { :href => "/search?q=#{m[:value]}&src=hash", :title => m[:value] }) : "##{m[:value]}");
			end
		end
	end
	
protected

	def around_save_hook()
		# save the main record first (so we have a content_id to pass to the join tables)
		yield
	
		# parse the post data and build associations, raise a rollback if anything fails
		text_body.scan(ENTITY_PATTERN) do |boundary,token,value|
			m = $~;
			
			if m[:token] == '@'
				# mention
				mention = User::where(:name => m[:value]).first;
				next unless mention;
				
				raise ActiveRecord::Rollback unless content_mentions.create({ :content_id => id, :user_id => mention.id });
			else
				# hashtag
				hashtag = Hashtag.where('tag = ?', m[:value]).first;

				unless hashtag
					hashtag = Hashtag.new({ :tag => m[:value] });
					raise ActiveRecord::Rollback unless hashtag.save();
				end
				
				raise ActiveRecord::Rollback unless content_hashtags.create({ :content_id => id, :hashtag_id => hashtag.id });
			end
		end
	end	

end
