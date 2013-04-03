class ReviewsController < ApplicationController

  before_filter :must_be_signed_in, except: [:index, :show]
  before_filter :find_review, only: [:show]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:review])

    if @review.save
      redirect_to @review
    else
      flash[:error] = "Something went wrong!"
      render :new
    end
  end

  def index
  end

  def show
    @vote = current_user.vote_for(@review.rid) if signed_in?
    @comment = Comment.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  # POST /reviews/:rid/votes
  def votes
    respond_to do |format|
      format.json {
        current_user.vote(params[:id], params[:dir])
        return render json: {}
      }
    end
  end

  # POST /reviews/:rid/comments
  def comments
    @review  = Review.find_by_rid(params[:id])
    @comment = @review.comments.build(parent_id: params[:parent_id], body: params[:body])

    # TODO: handle @comment.save
    # TODO: wire up ajax handler to append new comment with JS

    respond_to do |format|
      format.js {

      }
    end
  end

  private

  def find_review
    @review = Review.find_by_rid(params[:id])
    # return redirect_to reviews_path if @review.blank? # TODO
  end

end
