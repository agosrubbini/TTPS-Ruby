class Admin::UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]
  load_and_authorize_resource except: [ :profile, :update_profile ]


  # GET /categories or /categories.json
  def index
    @users = User.all
  end

  def profile
    @user = current_user
    render :profile  # Usará una nueva vista profile.html.erb
  end

  def update_profile
    @user = current_user
    if @user.update(profile_params)
      redirect_to admin_profile_edit_path, notice: "Perfil actualizado exitosamente."
    else
      render :profile_edit
    end
  end

  # GET /categories/1 or /categories/1.json
  def show
    authorize! :show, @user
  end

  # GET /categories/new
  def new
    authorize! :create, @user
    @user = User.new
  end

  # GET /categories/1/edit
  def edit
    authorize! :edit, @user
  end

  # POST /categories or /categories.json
  def create
    @user = User.new(user_params)
    @user.add_role_mio(params[:user][:role])
    if @user.save
      redirect_to admin_user_path(@user), notice: "Usuario creado exitosamente."
    else
      render :new
    end
  end

  def update
    authorize! :update, @user
    # Primero, manejar la asignación del rol
    @user.add_role_mio(params[:user][:role]) if params[:user][:role].present?

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "Usuario actualizado exitosamente."
    else
      # Agrega más detalle al error
      flash.now[:alert] = @user.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    authorize! :destroy, @user
    @user = User.find(params[:id])
    @user.update_column(:active, false)
    @user.update(password: SecureRandom.hex)
    if @user.soft_delete
      redirect_to admin_users_path, notice: "Usuario eliminado exitosamente."
    else
      redirect_to admin_users_path, alert: "No se pudo eliminar el usuario."
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
