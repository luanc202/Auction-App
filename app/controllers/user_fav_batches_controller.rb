class UserFavBatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @auction_batches = current_user.user_fav_batch.map(&:batch)
  end

  def create
    user_fav_batch = UserFavBatch.new(user_fav_batch_params)
    user_fav_batch.user_id = current_user.id
    if user_fav_batch.save
      handle_success(user_fav_batch)
    else
      handle_error('error')
    end
  end

  def destroy
    user_fav_batch = current_user.user_fav_batch.where(batch_id: params[:id]).first
    if user_fav_batch.destroy
      handle_success(user_fav_batch)
    else
      handle_error('error')
    end
  end

  private

  def user_fav_batch_params
    params.permit(:batch_id)
  end

  def handle_success(user_fav_batch)
    flash[:notice] = t('.success')
    redirect_to batch_path(user_fav_batch.batch)
  end

  def handle_error(message)
    flash[:alert] = t(message)
    redirect_to batch_path(user_fav_batch_params[:batch_id])
  end
end
