class AuctionItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    if !current_user.admin?
      redirect_to root_path, notice: 'Acesso não autorizado.'
    else
      @auction_items = AuctionItem.all
    end
  end

  def new
    @auction_item = AuctionItem.new
    @auction_item_categories = AuctionItemCategory.all
  end

  def create
    auction_item_params = params.require(:auction_item).permit(:name, :description, :weight, :width, :height, :depth,
                                                               :auction_item_category_id, :image)
    @auction_item = AuctionItem.new(auction_item_params)
    if @auction_item.save
      redirect_to @auction_item
    else
      flash.now[:notice] = 'Não foi possível cadastrar o Item de Leilão.'
      @auction_item_categories = AuctionItemCategory.all
      render :new
    end
  end

  def show
    @auction_item = AuctionItem.find(params[:id])
  end
end
