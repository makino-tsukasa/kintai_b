class User < ApplicationRecord
  before_save {self.email = email.downcase }
  validates :name, presence: true,  length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                                # 大文字と小文字の区別を無視する
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end