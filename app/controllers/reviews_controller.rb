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
        # TODO: check if a user is allowed to cast this vote on this review
        # You can revoke a vote (up -> nil), or vote the opposite (up -> down)
        # but can't vote same thing twice (up -> up)
        dir = params[:dir]
        rid = params[:id]
        review = Review.find_by_rid(rid)

        if current_user.can_vote?(rid, dir)
          (dir == 'up') ? review.vote_up : review.vote_down
          current_user.add_vote(rid, dir)
          return render json: { votes: review.votes }
        else
          return render json: {}
        end
      }
    end
  end

  private

  def find_review
    @review = Review.find_by_rid(params[:id])
    # return redirect_to reviews_path if @review.blank? # TODO
  end

end
