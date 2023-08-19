require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    has_many :aims
end

class Aim < ActiveRecord::Base
    belongs_to :user
end