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
    @vote = current_user.vote_for(@review.rid)
    @comment = Comment.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def votes
    respond_to do |format|
      format.json {
        current_user.vote(params[:id], params[:dir])
        return render json: {}
      }
    end
  end

  private

  def find_review
    @review = Review.find_by_rid(params[:id])
    # return redirect_to reviews_path if @review.blank? # TODO
  end

end
