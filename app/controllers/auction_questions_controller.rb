class AuctionQuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin, except: %i[create]

  def index
    @auction_questions = AuctionQuestion.where.missing(:auction_question_reply)
  end

  def create
    auction_question = AuctionQuestion.new(question_params)
    if auction_question.save
      redirect_to batch_path(auction_question.batch), notice: t('.create.success')
    else
      flash[:notice] = t('.create.error')
      redirect_to batch_path(auction_question.batch)
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
    redirect_to root_path, notice: t('access_denied') unless current_user.admin?
  end

  def question_params
    batch = Batch.find(params[:batch_id])
    params.permit(:question, :batch_id).merge(user: current_user).merge(batch:)
  end
end
