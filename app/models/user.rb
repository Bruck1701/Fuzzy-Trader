class User < ApplicationRecord
  include Clearance::User
  has_one :portfolio, :dependent => :destroy
  before_create :create_portfolio

  def create_portfolio
    portfolio = build_portfolio(:user_id => "id" )
  end


end
