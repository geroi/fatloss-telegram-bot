class User
  extend Forwardable
  def_delegators :@user, :inform, :update, :name 
  def initialize user
    @user = user
  end
end
