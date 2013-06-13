class ReviewsController < ApplicationController

  before_filter :must_be_signed_in, except: [:index, :show, :search]
  before_filter :find_review, only: [:show, :comments]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:review]) do |r|
      r.author   = current_user
      r.tag_list = params[:tag_list]
    end

    if @review.save
      redirect_to r_path(@review.rid)
    else
      flash[:error] = "Something went wrong!"
      render :new
    end
  end

  def index
    # TODO: customize review list if signed in
    @reviews = Review.all
  end

  def show
    @vote = current_user.vote_for(@review.rid) if signed_in?
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
    @comment = @review.comments.create do |cmt|
      cmt.author = current_user
      cmt.body   = params[:body]
      cmt.parent_id = params[:parent_id].to_i if params[:parent_id].present?
    end

    respond_to do |format|
      format.js
    end
  end

  def search
    if request.post?
      return redirect_to search_reviews_path(q: params[:q])
    else
      # TODO: weights
      @search = Review.search do
        fulltext(params[:q])
        paginate(page: params[:page])
      end
    end
  end

  def tags
    @tags = ActsAsTaggableOn::Tag.where("tags.name LIKE ?", "#{params[:query]}%").limit(7)

    respond_to do |format|
      format.json {
        render json: @tags.map(&:name)
      }
    end
  end

  private

  def find_review
    @review = Review.find_by_rid(params[:id])
    return render 'static/not_found' if @review.blank?
  end

end
