# frozen_string_literal: true

class User < ApplicationRecord
  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  geocoded_by :ip_address
  after_validation :geocode, if: ->(obj) { obj.current_sign_in_ip.present? && obj.current_sign_in_ip? }

  enum role: %i[user vip admin]
  after_initialize :set_default_role, if: :new_record?
  after_create { create_setting }
  validates :name, presence: true

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

  def ip_address
    return '24.9.64.99' if current_sign_in_ip == '127.0.0.1'

    current_sign_in_ip.to_s # current_sign_in_ip.class == IPAddr
  end
end
