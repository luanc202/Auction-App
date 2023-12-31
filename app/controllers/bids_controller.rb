class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_logged?

  def create
    bid_params = params.permit(:batch_id, :value)
    bid = Bid.new(bid_params)
    bid.user_id = current_user.id
    if bid.save
      redirect_to bid.batch, notice: t('.success')
    else
      redirect_to batch_path(bid.batch), alert: t('.error')
    end
  end

  private

  def user_logged?
    redirect_to new_user_session_path, notice: t('devise.unauthenticated') unless current_user
  end
end
