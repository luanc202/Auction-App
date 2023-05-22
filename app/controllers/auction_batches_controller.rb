class AuctionBatchesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :allow_if_admin, except: %i[index show won]
  before_action :set_auction_batch, only: %i[show edit update approved add_item add_item_save]

  def index
    @auction_batches = if current_user && current_user.admin?
                         AuctionBatch.where('end_date > ?', Time.current)
                       else
                         AuctionBatch.where('end_date > ?', Time.current).where(status: :approved)
                       end
  end

  def show
    @auction_batch = AuctionBatch.find(params[:id])
    if user_signed_in? && current_user.admin?
      @questions = AuctionQuestion.where(auction_batch_id: @auction_batch.id)
    else
      @questions = AuctionQuestion.where(auction_batch_id: @auction_batch.id, status: :display)
    end
  end

  def new
    @auction_batch = AuctionBatch.new
  end

  def create
    auction_batch_params = params.require(:auction_batch).permit(:code, :start_date, :end_date, :minimum_bid_amount,
                                                                 :minimum_bid_difference)
    @auction_batch = AuctionBatch.new(auction_batch_params)
    @auction_batch.created_by_user = current_user
    if @auction_batch.save
      redirect_to @auction_batch
    else
      flash.now[:notice] = 'Não foi possível cadastrar o Lote para Leilão.'
      render :new
    end
  end

  def approved
    @auction_batch.approved!
    @auction_batch.approved_by_user = current_user
    redirect_to @auction_batch
  end

  def add_item
    @auction_items = AuctionItem.where(auction_batch_id: nil)
  end

  def add_item_save
    @auction_item = AuctionItem.find(params[:auction_item_id])
    @auction_item.auction_batch = @auction_batch
    if @auction_item.save
      redirect_to @auction_batch
    else
      flash.now[:notice] = 'Não foi possível adicionar o Item ao Lote.'
      render :add_item
    end
  end

  def expired
    @auction_batches = AuctionBatch.where('end_date < ?', Time.current)
  end

  def finished
    @auction_batch = AuctionBatch.find(params[:id])
    @auction_batch.finished!
    won_auction_batch = WonAuctionBatch.new(auction_batch: @auction_batch, user: @auction_batch.bids.last.user)
    if won_auction_batch.save
      redirect_to expired_auction_batches_path, notice: 'Lote finalizado com sucesso.'
    else
      redirect_to expired_auction_batches_path, notice: 'Não foi possível finalizar o Lote.'
    end
  end

  def cancelled
    @auction_batch = AuctionBatch.find(params[:id])
    @auction_batch.cancelled!
    @auction_batch.auction_items.each do |auction_item|
      auction_item.auction_batch = nil
      auction_item.save
    end
    redirect_to expired_auction_batches_path, notice: 'Lote cancelado com sucesso.'
  end

  def won 
    auctions = current_user.won_auction_batch.map(&:auction_batch_id)
    @auction_batches = AuctionBatch.where(id: auctions)
  end

  private

  def allow_if_admin
    redirect_to root_path, notice: 'Acesso não autorizado.' unless current_user.admin?
  end

  def set_auction_batch
    @auction_batch = AuctionBatch.find(params[:id])
  end
end
