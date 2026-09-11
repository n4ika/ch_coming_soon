class WaitlistSignupForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string
  attribute :role, :string, default: "client"

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: %w[client professional] }
end