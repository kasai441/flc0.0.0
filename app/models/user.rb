# frozen_string_literal: true

class User < ApplicationRecord
  has_many :quizcards, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def set_total_time(answer_time)
    get_total_time
    get_practice_days
    get_total_practices
    self.practice_days += 1 unless get_last_practiced_at.between? User.today_range.first, User.today_range.last
    total_time = self.total_time + answer_time
    total_practices = self.total_practices + 1
    update_columns(total_time: total_time, practice_days: self.practice_days, last_practiced_at: Time.zone.today,
                   total_practices: total_practices)
    total_time
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.today_range
    Time.zone.today.beginning_of_day..Time.zone.today.end_of_day
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def get_total_time
    self.total_time = 0 if total_time.nil?
    total_time
  end

  def get_practice_days
    self.practice_days = 0 if self.practice_days.nil?
    self.practice_days
  end

  def get_last_practiced_at
    self.last_practiced_at = Time.zone.yesterday if last_practiced_at.nil?
    last_practiced_at
  end

  def get_total_practices
    self.total_practices = 0 if total_practices.nil?
    total_practices
  end
end
