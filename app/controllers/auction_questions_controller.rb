class AuctionQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin, except: %i[create]

  def index
    @auction_questions = AuctionQuestion.where.missing(:auction_question_reply)
  end

  def create
    auction_question_params = params.permit(:question, :batch_id)
    batch = Batch.find(auction_question_params[:batch_id])
    auction_question = AuctionQuestion.new(question: auction_question_params[:question], batch:,
                                           user: current_user)
    if auction_question.save
      redirect_to batch_path(auction_question.batch)
    else
      flash[:notice] = 'Não foi possível enviar a Pergunta.'
      redirect_to atch_path(auction_question.batch)
    end
  end

  def display
    auction_question_params = params.permit(:id)
    auction_question = AuctionQuestion.find(auction_question_params[:id])
    auction_question.display!
    redirect_to batch_path(auction_question.batch)
  end

  def hidden
    auction_question_params = params.permit(:id)
    auction_question = AuctionQuestion.find(auction_question_params[:id])
    auction_question.hidden!
    redirect_to batch_path(auction_question.batch)
  end

  private

  def check_if_admin
    redirect_to root_path, notice: 'Acesso não autorizado.' unless current_user.admin?
  end
end
