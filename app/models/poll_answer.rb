class PollAnswer < ActiveRecord::Base
	belongs_to :poll_option, :polymorphic => true
	belongs_to :user;
	
	attr_accessible :user_id, :option_no, :poll_id;
end