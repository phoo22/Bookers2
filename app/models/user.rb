class User < ApplicationRecord
  alias_attribute :email_address, :email
  has_one_attached :profile_image
  has_many :sessions, dependent: :destroy
  has_many :books
  has_secure_password

  normalizes :email, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    profile_image.variant(resize_to_limit: [ width, height ]).processed
  end
end
