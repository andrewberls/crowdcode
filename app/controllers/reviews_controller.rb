class ReviewsController < ApplicationController

  before_filter :must_be_signed_in, except: [:index, :show]
  before_filter :find_review, only: [:show]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(params[:review])

    if @review.save
      flash[:success] = "Post successful!"
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

  private

  def find_review
    @review = Review.find_by_rid(params[:id])
    return redirect_to reviews_path if @review.blank?
  end

end
