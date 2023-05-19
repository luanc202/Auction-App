class UserFavBatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @auction_batches = current_user.user_fav_batch.map(&:auction_batch)
  end

  def create
    user_fav_batch_params = params.permit(:auction_batch_id)
    user_fav_batch = UserFavBatch.new(user_fav_batch_params)
    user_fav_batch.user_id = current_user.id
    if user_fav_batch.save
      flash[:notice] = 'Lote adicionado aos favoritos'
      redirect_to auction_batch_path(user_fav_batch.auction_batch)
    else
      flash[:now] = 'Não foi possível adicionar o lote aos favoritos'
      redirect_to auction_batch_path(user_fav_batch_params[:auction_batch_id])
    end
  end

  def destroy
    user_fav_batch = current_user.user_fav_batch.where(auction_batch_id: params[:id]).first
    if user_fav_batch.destroy
      flash[:notice] = 'Lote removido dos favoritos'
      if params[:at_fav_page] == 'true'
        redirect_to user_fav_batches_path
      else
        redirect_to auction_batch_path(user_fav_batch.auction_batch)
      end
    else
      flash[:alert] = 'Não foi possível remover o lote dos favoritos'
      redirect_to auction_batch_path(user_fav_batch.auction_batch)
    end
  end
end