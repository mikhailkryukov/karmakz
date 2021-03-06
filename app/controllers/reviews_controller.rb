class ReviewsController < ApplicationController
  before_action :require_admin, only: [:destroy_by_admin]
  before_action :require_user, except: [:recent]
  before_action :require_same_user, only: [:update, :destroy]

  def new
    @user    = User.find(params[:user_id])
    @company = Company.find(params[:company_id])
    @review  = Review.new
  end

  def create
    @user          = User.find(params[:user_id])
    @company       = Company.find(params[:company_id])
    @review         = Review.new(review_params)
    @review.user    = current_user
    @review.company = @company

    if @review.save
      flash[:success] = 'You have successfully created Review.'
      redirect_to reviews_user_path(current_user)
    else
      flash[:danger] = 'You have to mark star and write a comment up to 500 characters!'
      redirect_to new_user_company_review_path(@user, @company)
    end

  end

  def edit
    @user    = User.find(params[:user_id])
    @company = Company.find(params[:company_id])
    @review  = Review.find(params[:id])
  end

  def update
    @user    = current_user
    @company = Company.find(params[:company_id])
    @review  = Review.find(params[:id])

    if @review.update(review_params)
      redirect_to reviews_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    Review.find(params[:id]).destroy
    redirect_to reviews_user_path(current_user)
  end

  def destroy_by_admin
    Review.find(params[:id]).destroy
    redirect_to flags_path
  end

  def listed_companies
    @companies = Company.all.order(created_at: :desc)
  end

  def recent
    @reviews = Review.all.order(created_at: :desc).limit(10)
  end

  def vote_useful
    @review_id = Review.find(params[:id]).id.to_s
    Vote.create(vote_type: 'useful', review_id: @review_id, user_id: current_user.id)
    @count = Vote.where(vote_type: 'useful', review_id: @review_id).count.to_s

    respond_to do |format|
      format.js
    end
  end

  def vote_funny
    @review_id = Review.find(params[:id]).id.to_s
    Vote.create(vote_type: 'funny', review_id: @review_id, user_id: current_user.id)
    @count = Vote.where(vote_type: 'funny', review_id: @review_id).count.to_s

    respond_to do |format|
      format.js
    end
  end

  def vote_cool
    @review_id = Review.find(params[:id]).id.to_s
    Vote.create(vote_type: 'cool', review_id: @review_id, user_id: current_user.id)
    @count = Vote.where(vote_type: 'cool', review_id: @review_id).count.to_s

    respond_to do |format|
      format.js
    end
  end

  private

  def review_params
    params.require(:review).permit(:stars, :content)
  end

end
