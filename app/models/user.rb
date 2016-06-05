# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  username               :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, uniqueness: true,
                       format: {
                         with: /\A[a-zA-Z0-9_\.]*\z/,
                         message: "Can't contain invalid characters"
                       }

  has_many :sit_ups
  has_many :push_ups
  has_many :user_stats
  has_many :courses

  scope :relevant, -> { where.not(username: 'test') }

  attr_writer :login

  def current_weight
    current_user_stat.try(:weight) || BigDecimal.new('100.0')
  end

  def current_user_stat
    user_stats.order(:date).last
  end

  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      # rubocop:disable Metrics/LineLength
      where(conditions.to_hash)
        .find_by(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
      # rubocop:enable Metrics/LineLength
    elsif conditions.key?(:username) || conditions.key?(:email)
      conditions[:email].downcase! if conditions[:email]
      find_by(conditions.to_hash)
    end
  end
end
