class UserController < ApplicationController
    def create
        @users = User.order("username ASC").pluck(:username)
        @index = @users.index(params[:username])
        @response = {}
        if @index == nil
            @user = User.new(:username => params[:username])
            @response = {"status": "OK"}
        end
        
        # TODO 8/4/2020: In case of username already in use, generate a new one here

        if @user != nil and @user.save
            render json: @response, status: :ok
        elsif @user != nil and @user.errors != nil
            render json: {"code": 406, "error": @user.errors.messages }, status: :not_acceptable
        else
            render json: {"code": 500 }, status: :internal_server_error
        end
    end
end
