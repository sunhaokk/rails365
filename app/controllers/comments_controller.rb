class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  def create
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
    @comment = @commentable.comments.new params.require(:comment).permit(:body).merge(user: current_user)
    @comment.save

    if resource.singularize.classify.constantize == Movie
      @comment.create_activity :create, owner: current_user, recipient: @commentable
    end
    @comments = @commentable.fetch_comments
  end
end
