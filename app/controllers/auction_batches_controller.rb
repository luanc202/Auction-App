class AuctionBatchesController < ApplicationController
  before_action :authenticate_user!

  def index
    if !current_user.admin?
      redirect_to root_path, notice: 'Acesso não autorizado.'
    else
      @auction_batches = AuctionBatch.all
    end
  end
end