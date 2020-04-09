class UserController < ApplicationController

    def generate_next_username(username)
        i = username.length - 1
        tmp = username
        tmp[i] += 1
        while i >= 0
            if tmp[i] > 90 and i != 0
                tmp[i] = 65
                tmp[i - 1] += 1
            end
            i -= 1
        end
        if tmp[0] > 90
            tmp.fill(65)
        end
        return tmp
    end

    def generate_unused_username(username, list, index)
        users_i = (index + 1) % (list.length)
        tmp = generate_next_username(username.unpack("C*"))
        while list[users_i] == tmp.pack("C*")
            users_i = (users_i + 1) % (list.length)
            tmp = generate_next_username(tmp)
        end
        return tmp.pack("C*")
    end

    def create
        # Check if parameters are ok
        if !params.has_key?(:username)
            render json: {"code": 406, "error": "you must give an username" }, status: :not_acceptable
            return
        end

        users = User.order("username ASC").pluck(:username)

        # Check if the database is not full (17576 is 26^3 possibilities)
        if users.length >= 17576
            render json: {"code": 507, "error": "no username available"}, status: :insufficient_storage
            return
        end

        index = users.index(params[:username])
        user = User.new(:username => params[:username])
        response = {}

        if user.valid? and index == nil
            response = {"status": "OK"}
        elsif user.valid?
            user.username = generate_unused_username(params[:username], users, index)
            response = {"username": user.username}
        elsif user.errors
            render json: {"code": 406, "error": user.errors.messages }, status: :not_acceptable
            return
        end

        # Commit model and check errors
        if user.save
            render json: response, status: :ok
        else
            render json: {"code": 500 }, status: :internal_server_error
        end
    end
end
