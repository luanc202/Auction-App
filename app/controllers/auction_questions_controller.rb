class AuctionQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin, except: %i[create]

  def index
    @auction_questions = AuctionQuestion.left_outer_joins(:auction_question_reply).where(auction_question_reply: { id: nil })
  end

  def create
    auction_question_params = params.permit(:question, :auction_batch_id)
    auction_batch = AuctionBatch.find(auction_question_params[:auction_batch_id])
    auction_question = AuctionQuestion.new(question: auction_question_params[:question], auction_batch:,
                                           user: current_user)
    if auction_question.save
      redirect_to auction_batch_path(auction_question.auction_batch)
    else
      flash[:notice] = 'Não foi possível enviar a Pergunta.'
      redirect_to auction_batch_path(auction_question.auction_batch)
    end
  end

  def display
    auction_question_params = params.permit(:id)
    auction_question = AuctionQuestion.find(auction_question_params[:id])
    auction_question.display!
    redirect_to auction_batch_path(auction_question.auction_batch)
  end

  def hidden
    auction_question_params = params.permit(:id)
    auction_question = AuctionQuestion.find(auction_question_params[:id])
    auction_question.hidden!
    redirect_to auction_batch_path(auction_question.auction_batch)
  end

  private

  def check_if_admin
    redirect_to root_path, notice: 'Acesso não autorizado.' unless current_user.admin?
  end
end
