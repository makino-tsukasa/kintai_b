class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :set_user_from_attendance, only: [:create]
  before_action :logged_in_user, only: [:create, :update, :edit]
  before_action :admin_or_correct_user, only: [:create, :update, :edit]

  def create
    # @user = User.find(params[:user_id])
    @attendance = @user.attendances.find_by(worked_on: Date.today)
    if @attendance.started_at.nil?
      @attendance.update_attributes(started_at: current_time)
      flash[:info] = 'おはようございます。'
    elsif @attendance.finished_at.nil?
      @attendance.update_attributes(finished_at: current_time)
      flash[:info] = 'おつかれさまでした。'
    else
      flash[:danger] = 'トラブルがあり、登録出来ませんでした。'
    end
    redirect_to(@user)
  end
  
  def edit
    @first_day = Date.parse(params[:date])
    @last_day = @first_day.end_of_month
    @dates = @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
  end
  
  def update
    if attendances_invalid?
      attendances_params.each do |id, item|
      attendance = Attendance.find(id)
      attendance.update_attributes!(item)
    end
      flash[:success] = '勤怠情報を更新しました。'
      redirect_to user_url(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end

  private
    def attendances_params
      params.permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
    
    def set_user_from_attendance
      @user = User.find(params[:user_id])
    end

end