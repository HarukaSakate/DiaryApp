user.rb
class User < ApplicationRecord
    devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

    validates :username, presence: true, uniqueness: { case_sensitive: false }

    has_many :dairies
end
