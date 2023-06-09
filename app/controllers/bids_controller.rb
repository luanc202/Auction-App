class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_user_logged

  def create
    bid_params = params.permit(:auction_batch_id, :value)
    bid = Bid.new(bid_params)
    bid.user_id = current_user.id
    if bid.save
      redirect_to bid.auction_batch, notice: 'Lance dado com sucesso!'
    else
      redirect_to auction_batch_path(bid.auction_batch), alert: 'Não foi possível realizar o lance.'
    end
  end

  private

  def is_user_logged
    redirect_to new_user_session_path, notice: 'Por favor, faça login para dar lances.' unless current_user
  end
end
