class AuctionQuestionRepliesController < ApplicationController
  before_action :authenticate_user!, :check_if_admin

  def index
    @auction_questions = AuctionQuestion.where.missing(:auction_question_reply)
  end

  def create
    reply = AuctionQuestionReply.new(question_replies_params(current_user))
    if reply.save
      redirect_to batch_path(reply.auction_question.batch)
    else
      flash[:notice] = t('.create.error')
      redirect_to auction_question_replies_path
    end
  end

  private

  def question_replies_params(user)
    params.permit(:reply, :auction_question_id, :user_id).merge(user:)
  end

  def check_if_admin
    redirect_to root_path, notice: t('access_denied') unless current_user.admin?
  end
end
