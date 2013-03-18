class Comment < Content
	belongs_to :user;

	attr_accessible :content_id, user_id;
end