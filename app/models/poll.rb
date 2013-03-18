class Poll < Content
	has_many :poll_options;
	has_many :poll_answers, { :through => :poll_options }
	
	attr_accessible :user_id, :question, :option_no;
	validates :text_body, :presence => true, :length => { :maximum => 1000 };
	
	after_initialize :after_init_hook;
	after_save :after_save_hook;
	
	def after_init_hook(attributes = {}, options = {})
		@max_option = poll_options.maximum(:option_no) || 0;
	end	
	
	def after_save_hook()
		@max_option = poll_options.maximum(:option_no) || 0;
	end
	
	def add_option(option_value)
		raise ArgumentError, 'Option must be a string with no more than 150 characters' unless (option_value && option_value.length() <= 150);
		
		@max_option += 1;
		poll_options.build({ :poll_id => id, :option_no => @max_option, :content => option_value });
	end
	
	def add_answer(user_id, option_no)
		option = poll_options.where('option_no = ?', option_no).first;
		raise RecordNotFound unless option;
		
		option.add_answer(user_id);
	end	
end