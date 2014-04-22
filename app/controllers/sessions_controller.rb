class SessionsController < ApplicationController

  skip_before_filter :authenticate
  layout 'login'
  
  def new
  end

  def create
    # allow before_filter to override user
    @user ||= User.authenticate(params[:nick], params[:password])
    if @user
      login @user
      if session[:return_to].present?
        redirect_to_url = session[:return_to]
        session[:return_to] = nil
      else
        redirect_to_url = root_url
      end
      redirect_to redirect_to_url
    else
      flash.now.alert = I18n.t('sessions.login_invalid')
      render "new"
    end
  end

  def destroy
    logout
    if defined? FoodsoftConfig[:homepage]
      redirect_to FoodsoftConfig[:homepage]
    else
      redirect_to login_url, :notice => I18n.t('sessions.logged_out')
    end
  end

  # redirect to root, going to default foodcoop when none given
  # this may not be so much session-related, but it must be somewhere
  def redirect_to_foodcoop
    redirect_to root_path
  end

end
