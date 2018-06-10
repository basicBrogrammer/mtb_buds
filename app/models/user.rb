class User < ApplicationRecord
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  after_create { self.create_setting }
  validates_presence_of :name

  has_many :rides, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :participating_rides, through: :participations, source: :ride
  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_one_attached :avatar
  delegate :comment_notifications?, :participation_notifications?, to: :setting

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def accepted_participant?(ride)
    participations.accepted.find_by(ride_id: ride.id).present?
  end
end
