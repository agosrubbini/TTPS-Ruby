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
      can :manage, User, roles: { name: 'employee' }  # El gerente puede gestionar usuarios con rol 'employee'
      cannot :create, User, roles: { name: 'admin' }   # El gerente no puede crear usuarios con rol 'admin'
      cannot :update, User, roles: { name: 'admin' }   # El gerente no puede modificar usuarios con rol 'admin'
    elsif user.has_role?(:employee)
      can :manage, Product
      can :manage, Sale
      cannot :manage, User  # El empleado no puede gestionar usuarios
    end
  end
end
