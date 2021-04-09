class SessionsController < ApplicationController
  # code from multi-users lab for MSCI 342 by Mark Smucker #
  def new
      if current_user.present?
          if current_user_is_manager
              redirect_to manager_dashboard_url
          else
              redirect_to user_dashboard_url
          end
      end
  end

  def create
    user = User.find_by(watiam: params[:watiam].downcase)
    if !user
        user = Manager.find_by(watiam: params[:watiam].downcase)
    end
    if user && user.authenticate(params[:password])
      log_in user
      get_dashboard
    else
      flash.now[:alert] = 'Cannot log you in. Invalid Watiam or Password.'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path, notice: 'Logged out.'
  end
end
