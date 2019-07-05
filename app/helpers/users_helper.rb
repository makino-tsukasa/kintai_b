module UsersHelper
  # 基本時間などの値を、指定の書式にフォーマットして返す
  def format_basic_time(time)
    format("%.2f", ((time.hour * 60) + time.min)/60.0)
  end
end