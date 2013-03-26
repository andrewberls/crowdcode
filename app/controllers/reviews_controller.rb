class ReviewsController < ApplicationController
  before_filter :must_be_signed_in, except: [:index, :show]

  def new
    @review = Review.new
  end

  def index
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

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
