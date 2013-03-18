# Join table for users->content
class ContentMention < ActiveRecord::Base
	belongs_to :user;
	belongs_to :content, { :polymorphic => true };
	
	attr_accessible :content_id;
	attr_accessible :user_id;
end