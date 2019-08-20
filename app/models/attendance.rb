class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  validate :finished_at_is_invalid_without_a_started_at
  validate :finished_at_must_be_later_than_started_at

  def finished_at_is_invalid_without_a_started_at
      errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  # 追加機能7
  def finished_at_must_be_later_than_started_at
    if started_at.present? && finished_at.present?
      errors.add(:finished_at, "が出勤時間よりも早いため登録できません") if started_at > finished_at
    end
  end
end
