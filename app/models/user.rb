# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: %i[user vip admin]

  validates :name, :location, :email, presence: true
  geocoded_by :location

  after_initialize :set_default_role, if: :new_record?
  after_create { create_setting }
  after_validation :geocode, if: ->(obj) { obj.location.present? && obj.location_changed? }

  has_many :rides, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :participating_rides, through: :participations, source: :ride
  has_many :notifications, -> { order(read_at: :desc) }, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :setting, dependent: :destroy
  has_one_attached :avatar

  delegate :ride_notifications?, :comment_notifications?,
           :participation_notifications?, to: :setting

  def set_default_role
    self.role ||= :vip
  end

  def accepted_participant?(ride)
    participations.accepted.find_by(ride_id: ride.id).present?
  end
end
