class HomeController < ApplicationController
  def index
	@polls = Poll.all;
	
	respond_to do |format|
		format.html
		format.json { render :json => @polls }
	end
  end
  
	def something
		#poll = Poll.new( {:user_id => 1, :question => 'How are you feeling today?', :text_body => 'I feel sooooo good this morning! #sunshine #goodtimes @jasonlarke'} );
		#poll.add_option('Pretty good!');
		#poll.add_option('Not so good :(');
		#poll.save();
		poll = Poll.find(5);
		poll.add_answer(1, 2);
		poll.save();
	end
end
