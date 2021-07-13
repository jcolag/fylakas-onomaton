# frozen_string_literal: true

# Handle requests relating to names
class NamesController < ApplicationController
  before_action :authenticate_user_or_validate_api_key!
  before_action :set_name, only: %i[show edit update destroy]

  # GET /names or /names.json
  def index
    respond_to do |format|
      format.json { render json: { status: 'failed' } }
    end if @user.nil?
    @names = Name.all
  end

  # GET /names/1 or /names/1.json
  def show
    respond_to do |format|
      format.json { render json: { status: 'failed' } }
    end if @user.nil?
  end

  # GET /names/new
  def new
    respond_to do |format|
      format.json { render json: { status: 'failed' } }
    end if @user.nil?
    @name = Name.new
  end

  # GET /names/1/edit
  def edit
    respond_to do |format|
      format.json { render json: { status: 'failed' } }
    end if @user.nil?
  end

  # POST /names or /names.json
  def create
    respond_to do |format|
      format.json { render json: { status: 'failed' } }
    end if @user.nil?
    @name = Name.new(name_params)

    respond_to do |format|
      if @name.save
        format.html { redirect_to @name, notice: 'Name was successfully created.' }
        format.json { render :show, status: :created, location: @name }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /names/1 or /names/1.json
  def update
    respond_to do |format|
      format.json { render json: { status: 'failed' } }
    end if @user.nil?
    respond_to do |format|
      if @name.update(name_params)
        format.html { redirect_to @name, notice: 'Name was successfully updated.' }
        format.json { render :show, status: :ok, location: @name }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /names/1 or /names/1.json
  def destroy
    respond_to do |format|
      format.json { render json: { status: 'failed' } }
    end if @user.nil?
    @name.destroy
    respond_to do |format|
      format.html { redirect_to names_url, notice: 'Name was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_name
    @name = Name.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def name_params
    params.require(:name).permit(:name, :pin, :share)
  end

  def authenticate_user_or_validate_api_key!
    return validate_api_key! if params['format'] == 'json'
    return authenticate_user!
  end

  def validate_api_key!
    key = params.has_key?('apiKey') ? params['apiKey'] : 'not-a-real-key'
    activation = Activation.find_by_activated key
    @user = User.find activation.user_id unless activation.nil?
  end
end
