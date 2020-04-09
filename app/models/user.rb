class User < ApplicationRecord
    validate :username_validation 

    def username_validation
        if username.length != 3
            errors.add(:username, "must be exactly 3 characters.")
        end
        username.each_byte do |c| 
            if c < 65 or c > 90
                errors.add(:username, "must have only uppercase characters.")
                return
            end
        end
    end
end
