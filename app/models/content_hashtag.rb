class ContentHashtag < ActiveRecord::Base
	belongs_to :hashtag;
	belongs_to :content, { :polymorphic => true };
	
	attr_accessible :content_id;
	attr_accessible :hashtag_id;
end