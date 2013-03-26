class ReviewsController < ApplicationController
  before_filter :must_be_signed_in, except: [:index, :show]

  def new
    @review = Review.new
  end

  def index
  end

  def create
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
