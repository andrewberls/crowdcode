class ReviewsController < ApplicationController

  before_filter :must_be_signed_in, except: [:index, :show]
  before_filter :find_review, only: [:show]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:review]) do |r|
      r.author = current_user
    end

    if @review.save
      redirect_to r_path(@review.rid)
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
    @review = Review.find_by_rid(params[:id])
    body    = params[:body]

    if params[:parent_id].present?
      # Replying to a comment
      parent_id = params[:parent_id].to_i
      @parent   = Comment.find(parent_id)
      raise "replying to parent id: #{parent_id}"
    else
      # Posting a parent comment
      @comment = @review.comments.create do |cmt|
        cmt.body   = body
        cmt.author = current_user
      end
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def find_review
    @review = Review.find_by_rid(params[:id])
    # return redirect_to reviews_path if @review.blank? # TODO
  end

end
