class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  # GET /categories or /categories.json
  def index
    @users = User.all
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @user = User.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @user = User.new(user_params)
    @user.add_role_mio(params[:user][:role])
    if @user.save
      redirect_to admin_user_path(@user), notice: 'Usuario creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'Usuario actualizado exitosamente.'
    else
      render :edit
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @user.update(active: false) 

    respond_to do |format|
      format.html { redirect_to admin_user_path, status: :see_other, notice: "Category was successfully destroyed." }
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone, :encrypted_password, :entry_date, :active, :password, :password_confirmation)
  end
end
