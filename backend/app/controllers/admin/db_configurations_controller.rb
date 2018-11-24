class Admin::DbConfigurationsController < ApplicationController
  before_action :set_admin_db_configuration, only: [:show, :edit, :update, :destroy]

  # GET /admin/db_configurations
  # GET /admin/db_configurations.json
  def index
    @admin_db_configurations = Admin::DbConfiguration.using(read_replica_db).all
  end

  # GET /admin/db_configurations/1
  # GET /admin/db_configurations/1.json
  def show
  end

  # GET /admin/db_configurations/new
  def new
    @admin_db_configuration = Admin::DbConfiguration.new
  end

  # GET /admin/db_configurations/1/edit
  def edit
  end

  # POST /admin/db_configurations
  # POST /admin/db_configurations.json
  def create
    @admin_db_configuration = Admin::DbConfiguration.new(admin_db_configuration_params)

    respond_to do |format|
      if Admin::DbConfiguration.save(@admin_db_configuration.id, admin_db_configuration_params)
        format.html { redirect_to @admin_db_configuration, notice: 'Db configuration was successfully created.' }
        format.json { render :show, status: :created, location: @admin_db_configuration }
      else
        format.html { render :new }
        format.json { render json: @admin_db_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/db_configurations/1
  # PATCH/PUT /admin/db_configurations/1.json
  def update
    respond_to do |format|
      if Admin::DbConfiguration.using(master_db).update(@admin_db_configuration.id, admin_db_configuration_params)
        format.html { redirect_to @admin_db_configuration, notice: 'Db configuration was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_db_configuration }
      else
        format.html { render :edit }
        format.json { render json: @admin_db_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/db_configurations/1
  # DELETE /admin/db_configurations/1.json
  def destroy
    Admin::DbConfiguration.using(master_db).destroy(@admin_db_configuration.id)
    respond_to do |format|
      format.html { redirect_to admin_db_configurations_url, notice: 'Db configuration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_db_configuration
      @admin_db_configuration = Admin::DbConfiguration.using(read_replica_db).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_db_configuration_params
      params.require(:admin_db_configuration).permit(:key, :value)
    end
end
