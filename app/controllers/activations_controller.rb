class ActivationsController < ApplicationController
  before_action :set_activation, only: %i[ show edit update destroy ]

  # GET /activations or /activations.json
  def index
    @activations = Activation.all
  end

  # GET /activations/1 or /activations/1.json
  def show
  end

  # GET /activations/new
  def new
    @activation = Activation.new
  end

  # GET /activations/1/edit
  def edit
  end

  # POST /activations or /activations.json
  def create
    @activation = Activation.new(activation_params)

    respond_to do |format|
      if @activation.save
        format.html { redirect_to @activation, notice: "Activation was successfully created." }
        format.json { render :show, status: :created, location: @activation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activations/1 or /activations/1.json
  def update
    respond_to do |format|
      if @activation.update(activation_params)
        format.html { redirect_to @activation, notice: "Activation was successfully updated." }
        format.json { render :show, status: :ok, location: @activation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activations/1 or /activations/1.json
  def destroy
    @activation.destroy
    respond_to do |format|
      format.html { redirect_to activations_url, notice: "Activation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activation
      @activation = Activation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def activation_params
      params.require(:activation).permit(:code, :device_info)
    end
end
