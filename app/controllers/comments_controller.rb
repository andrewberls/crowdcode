class CommentsController < ApplicationController
  before_filter :must_be_signed_in, :except => [:index, :show]
  def new
    @comment = Comment.new(:parent_id => params[:parent_id])
  end

  def index
  end

  def create
  end

  def update
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to posts_path
  end
end
