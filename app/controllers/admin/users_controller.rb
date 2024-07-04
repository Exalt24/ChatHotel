class Admin::UsersController < AdminController
    before_action :set_admin_user, only: [ :show, :destroy, :toggle_admin ]

    def index
      @admin_users = User.where.not(id: [ current_user.id, 1 ])

      if params[:search].present?
        search_term = params[:search].downcase
        @admin_users = @admin_users.where("LOWER(first_name) LIKE :search OR LOWER(last_name) LIKE :search OR LOWER(email) LIKE :search", search: "%#{search_term}%")
      end

      case params[:order]
      when "name_asc"
        @admin_users = @admin_users.order(first_name: :asc, last_name: :asc)
      when "name_desc"
        @admin_users = @admin_users.order(first_name: :desc, last_name: :desc)
      when "id_asc"
        @admin_users = @admin_users.order(id: :asc)
      when "id_desc"
        @admin_users = @admin_users.order(id: :desc)
      when "email_asc"
        @admin_users = @admin_users.order(email: :asc)
      when "email_desc"
        @admin_users = @admin_users.order(email: :desc)
      else
        @admin_users = @admin_users.order(id: :asc)
      end

      @admin_users = @admin_users.paginate(page: params[:page], per_page: 10)
    end


    def show
    end

    def destroy
      @admin_user.destroy!

      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def toggle_admin
      if @admin_user.admin?
        @admin_user.update(admin: false)
        message = "Admin privileges were successfully removed."
      else
        @admin_user.update(admin: true)
        message = "User was successfully given admin privileges."
      end

      respond_to do |format|
        format.html { redirect_to admin_user_path(@admin_user), notice: message }
        format.json { render :show, status: :ok, location: @admin_user }
      end
    end


    private

    def set_admin_user
      @admin_user = User.find(params[:id])
    end

    def admin_user_params
      params.require(:users).permit(
        :id, :first_name, :last_name, :mobile_number, :admin
      )
    end
end
