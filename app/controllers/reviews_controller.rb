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
    @vote = current_user.votes.find { |v| v['rid'] == @review.rid } || {}
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
        # TODO: how to undo votes? Undoing an upvote is like sending a passive downvote,
        # but we don't want this reflected in the view (highlight down arrow)
        # Tracking active votes is tough, because old active votes (the original vote before redo)
        # will match and display. Solution: timestamps or ???
        rid = params[:id]
        dir = params[:dir]
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
