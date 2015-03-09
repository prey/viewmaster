

class GeneralModel < ActiveRecord::Base
  belongs_to :user
  validates :settings, presence: true
end

class User < ActiveRecord::Base
  has_many :general_models
end
