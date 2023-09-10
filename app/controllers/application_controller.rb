class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :reject_blocked_cpf

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name cpf])
  end

  def reject_blocked_cpf
    return unless user_signed_in? && BlockedCpf.find_by(cpf: current_user.cpf)

    flash.now[:alert] = 'Sua conta está suspensa.'
  end

  def home_page?
    request.path == root_path
  end
end
