class BlockedCpfsController < ApplicationController
  before_action :authenticate_user!, :check_if_admin

  def index
    @blocked_cpfs = BlockedCpf.all
    @new_blocked_cpf = BlockedCpf.new
  end

  def create
    blocked_cpf_params = params.require(:blocked_cpf).permit(:cpf)
    blocked_cpf = BlockedCpf.new(blocked_cpf_params)
    if blocked_cpf.save
      redirect_to blocked_cpfs_path, notice: t('.success')
    else
      redirect_to blocked_cpfs_path, alert: t('.error')
    end
  end

  def destroy
    blocked_cpf = BlockedCpf.find(params[:id])
    blocked_cpf.destroy
    redirect_to blocked_cpfs_path, notice: t('.success')
  end

  private

  def check_if_admin
    redirect_to root_path, notice: t('access_denied') unless current_user.admin?
  end
end
