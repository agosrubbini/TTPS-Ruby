class SailsController < ApplicationController
  before_action :set_sail, only: %i[ show edit update destroy ]

  # GET /sails or /sails.json
  def index
    @sails = Sail.all
  end

  # GET /sails/1 or /sails/1.json
  def show
  end

  # GET /sails/new
  def new
    @sail = Sail.new
  end

  # GET /sails/1/edit
  def edit
  end

  # POST /sails or /sails.json
  def create
    @sail = Sail.new(sail_params)

    respond_to do |format|
      if @sail.save
        format.html { redirect_to @sail, notice: "Sail was successfully created." }
        format.json { render :show, status: :created, location: @sail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sails/1 or /sails/1.json
  def update
    respond_to do |format|
      if @sail.update(sail_params)
        format.html { redirect_to @sail, notice: "Sail was successfully updated." }
        format.json { render :show, status: :ok, location: @sail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sails/1 or /sails/1.json
  def destroy
    @sail.destroy!

    respond_to do |format|
      format.html { redirect_to sails_path, status: :see_other, notice: "Sail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sail
      @sail = Sail.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sail_params
      params.expect(sail: [ :completed_at, :total_amount, :employee_id, :client_dni ])
    end
end
