class ItemsController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.find(params[:id])
    else
      item = Item.find(params[:id])
    end
    render json: item, include: :user

  end

  def create
    item = Item.new(item_params)
    item.user_id = params[:user_id]
    item.save
    render json: item, status: 201
  end

  private

  def render_not_found_response
    render json: { error: "User not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
