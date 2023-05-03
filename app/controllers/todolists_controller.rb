class TodolistsController < ApplicationController
  def new
    @list = List.new
  end

  def create
    list = List.new(list_params)
    list.save
    score = Language.get_data(list_params[:body])
    data = Vision.get_image_data(list.image)
    p data
    if data.value?("LIKELY") || data.value?("VERY_LIKELY")
      list.image.purge
      list.destroy
      redirect_to todolists_new_path
    else
      redirect_to todolist_path(list.id)
    end
  end

  def index
    @lists = List.all
  end

  def show
    @list = List.find(params[:id])
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    list = List.find(params[:id])
    list.score = Language.get_data(list_params[:body])
    list.update(list_params)
    redirect_to todolist_path(list.id)
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to todolists_path
  end

  private

  def list_params
    params.require(:list).permit(:title, :body, :image)
  end

end
