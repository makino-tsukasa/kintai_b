class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include AttendancesHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  # beforフィルター
  
  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
  
  # login済みuserか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  #正しいuserかどうか確認
  def correct_user
    unless current_user?(@user)
      flash[:danger] = "正しいユーザーではないため権限がありません。"    
      redirect_to(root_url)
    end
  end
  
  # 管理者かどうか確認
  def admin_user
    unless current_user.admin?
      flash[:danger] = "管理者以外権限がありません。"
      redirect_to(root_url)
    end  
  end  

  # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "権限がありません。"
      redirect_to(root_url)
    end
  end
end
