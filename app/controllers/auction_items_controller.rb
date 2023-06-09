class AuctionItemsController < ApplicationController
  before_action :authenticate_user!, :check_if_admin

  def index
      @auction_items = AuctionItem.all
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

  private

  def check_if_admin
    redirect_to root_path, notice: 'Acesso não autorizado.' unless current_user.admin?
  end
end
