class Portfolio < ApplicationRecord

    belongs_to :user
    has_many :assets
    # validates_uniqueness_of :user_id, :message => “User can only have one Portfolio”
    # validates :user_id, presence: true

end
