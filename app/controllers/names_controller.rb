# frozen_string_literal: true

# Handle requests relating to names
class NamesController < ApplicationController
  before_action :authenticate_user_or_validate_api_key!
  before_action :set_name, only: %i[show edit update destroy]
  skip_before_action :verify_authenticity_token, only: %i[create]

  # GET /names or /names.json
  def index
    @names = Name.where('user_id = ?', current_user.nil? ? nil : current_user.id)
  end

  # GET /names/1 or /names/1.json
  def show; end

  # GET /names/new
  def new
    @name = Name.new
  end

  # GET /names/1/edit
  def edit
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: { status: 'failed' } } if @user.nil?
    end
  end

  # POST /names or /names.json
  def create
    @name = Name.new name: name_from_params(params), user_id: userid

    respond_to do |format|
      if userid.nil?
        format.json { render json: { status: 'failed' } }
      else
        create_respond(format)
      end
    end
  end

  # PATCH/PUT /names/1 or /names/1.json
  def update
    respond_to do |format|
      if @user.nil? && current_user.nil?
        format.json { render json: { status: 'failed' } }
      else
        update_respond(format)
      end
    end
  end

  # DELETE /names/1 or /names/1.json
  def destroy
    @name.destroy unless @user.nil? && current_user.nil?
    respond_to do |format|
      format.html { redirect_to names_url, notice: 'Name was successfully destroyed.' }
      if @user.nil?
        format.json { render json: { status: 'failed' } }
      else
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_name
    @name = Name.find_by_id(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def name_params
    params.require(:name).permit(:pin, :share)
  end

  def authenticate_user_or_validate_api_key!
    return validate_api_key! if request.format == 'json'

    authenticate_user!
  end

  def validate_api_key!
    key = params.key?('apiKey') ? params['apiKey'] : 'not-a-real-key'
    activation = Activation.find_by_activated key
    @user = User.find activation.user_id unless activation.nil?
  end

  def create_respond(format)
    if @name.save
      format.html { redirect_to @name, notice: 'Name was successfully created.' }
      format.json { render :show, status: :created, location: @name }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @name.errors, status: :unprocessable_entity }
    end
  end

  def update_respond(format)
    if @name.update(name_params)
      format.html { redirect_to @name, notice: 'Name was successfully updated.' }
      format.json { render :show, status: :ok, location: @name }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @name.errors, status: :unprocessable_entity }
    end
  end

  def userid
    return nil if @user.nil? && current_user.nil?

    @user.nil? ? current_user.id : @user.id
  end

  def name_from_params(params)
    n = params.require :name
    return n if n.instance_of? String

    n[:name]
  end
end
