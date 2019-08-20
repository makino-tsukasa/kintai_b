class UsersController < ApplicationController
  before_action :set_user,       only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_user,     only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [:show, :edit, :update]

  def index
    if params[:search].present?
      @users = User.paginate(page: params[:page]).search(params[:search])
    else
      @users = User.paginate(page: params[:page])
    end
  end
  
  def show
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
       record = @user.attendances.build(worked_on: day)
       record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規作成に成功しました。"
      redirect_to @user # redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    @users = User.all
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      @users.each do |user|
        user.update_attributes!(basic_info_params)
      end
    end
    flash[:success] = "全ユーザーの基本情報を更新しました。"
    redirect_to users_url
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "基本情報の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    render 'edit_basic_info'
  end  
    

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, 
                                   :password,:password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end

end
