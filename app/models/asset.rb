class Asset < ApplicationRecord

    belongs_to :portfolio
    has_and_belongs_to_many :currentvalues
end
