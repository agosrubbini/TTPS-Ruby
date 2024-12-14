class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from CanCan::AccessDenied, with: :handle_access_denied

  def handle_access_denied
    @error_code = "401"
    @error_message = "Acceso denegado: No tienes los permisos necesarios para realizar esta acción."

    render "errors/unauthorized", status: :unauthorized
  end

end
