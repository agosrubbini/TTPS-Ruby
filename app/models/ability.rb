# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Si el usuario no está presente, se crea un objeto vacío

    if user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:manager)
      can :manage, Product
      can :manage, Sale
      can :create, User

      can :manage, User, roles: { name: "employee" }  # El gerente puede gestionar usuarios con rol 'employee'
      cannot :create, User, roles: { name: "admin" }   # El gerente no puede crear usuarios con rol 'admin'
      cannot :update, User, roles: { name: "admin" }   # El gerente no puede modificar usuarios con rol 'admin'
    elsif user.has_role?(:employee)
      can :manage, Product
      can :manage, Sale
      can [ :show, :update ], User, id: user.id
      cannot :manage, User  # El empleado no puede gestionar usuarios
      cannot :create, User
    else
      # Para usuarios no autenticados o sin roles
      cannot :manage, :all
      cannot :manage, Sale
    end
  end
end
