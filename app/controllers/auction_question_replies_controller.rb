class AuctionQuestionRepliesController < ApplicationController
  before_action :authenticate_user!, :check_if_admin

  def index
    @auction_questions = AuctionQuestion.where.missing(:auction_question_reply)
  end

  def create
    reply_params = params.permit(:reply, :auction_question_id)
    reply = AuctionQuestionReply.new(reply: reply_params[:reply], auction_question_id: reply_params[:auction_question_id],
                                     user: current_user)
    if reply.save
      redirect_to batch_path(reply.auction_question.batch)
    else
      flash[:notice] = 'Não foi possível enviar a Pergunta.'
      redirect_to auction_question_replies_path
    end
  end

  private

  def check_if_admin
    redirect_to root_path, notice: 'Acesso não autorizado.' unless current_user.admin?
  end
end
