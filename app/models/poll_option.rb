class PollOption < ActiveRecord::Base
	self.primary_keys = :poll_id, :option_no;

	belongs_to :poll;
	has_many :poll_answers;
	
	attr_accessible :poll_id, :content, :active, :option_no;
	
	def add_answer(user_id)
		poll_answers.build( { :poll_id => poll.id, :option_no => option_no, :user_id => user_id } );
	end	
end