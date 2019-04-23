module ApplicationHelper

  #application.html.erbの<head><title>に入る  
  def full_title(page_title = "")
    base_title = "勤怠管理システム"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

end
