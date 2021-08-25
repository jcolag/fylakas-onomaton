# frozen_string_literal: true

# Handle requests relating to activation processing
class ActivationsController < ApplicationController
  before_action :authenticate_user_or_validate_api_key!
  before_action :set_activation, only: %i[edit update destroy]
  before_action :set_header, only: %i[show new]
  skip_before_action :verify_authenticity_token, only: %i[verify]

  # GET /activations or /activations.json
  def index
    uid = current_user.nil? ? nil : current_user.id
    @activations = Activation.where('user_id = ?', uid)
  end

  # GET /activations/1 or /activations/1.json
  def show
    set_activation
    json = json_show_slug.to_json

    respond_to do |format|
      format.html { render :show, location: @activation }
      format.json { render json: json }
    end
  end

  # GET /activations/new
  def new
    code, json = generate_code 5, params
    act = Activation.new({
                           code: code,
                           device_info: params['device']
                         })
    act.save

    respond_to do |format|
      format.html { redirect_to action: :show }
      format.json { render json: json.gsub(/"000"/, act.id.to_s), status: :ok }
    end
  end

  # GET /activations/1/edit
  def edit; end

  # POST /activations or /activations.json
  def create
    return update if activation_params.key? 'code'

    @activation = Activation.new(activation_params)

    respond_to do |format|
      create_respond(format)
    end
  end

  # PATCH/PUT /activations/1 or /activations/1.json
  def update
    @activation = Activation.find_by_code activation_params['code']
    return redirect_to Activation.last, notice: 'No such activation code.' if @activation.nil?

    code, = generate_code 48, nil
    return redirect_to Activation.last, notice: 'Activation code has expired.' if @activation.old?

    @activation.activated = code
    @activation.user_id = current_user.id

    # Use information (hopefully) in @activation.device to
    # to send the API key back to the waiting device.

    respond_to do |format|
      update_respond(format)
    end
  end

  # DELETE /activations/1 or /activations/1.json
  def destroy
    @activation.destroy
    respond_to do |format|
      format.html { redirect_to activations_url, notice: 'Activation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def verify
    code = params['code']
    activation = Activation.find_by_code code
    result = { code: code, activated: verify_activated(activation) }
    respond_to do |format|
      format.json { render json: result.to_json }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_activation
    return unless params.key? :id

    @activation = Activation.where 'id = ?', params[:id]
    @activation = @activation.first unless @activation.nil?
    return unless params.key? :code

    @activation = Activation.find_by_code(params[:code]) if @activation.nil?
  end

  # Only allow a list of trusted parameters through.
  def activation_params
    params.require(:activation).permit(:code, :device_info, :user)
  end

  def generate_code(length, params)
    letters = Array('A'..'Z') + Array('0'..'9')
    code = Array.new(length) { letters.sample }.join
    result = { code: code, params: params, result: :ok, id: '000' }
    [code, result.to_json]
  end

  def verify_activated(activation)
    return nil if activation.nil? || activation.activated.nil?
    return activation.code if activation.old?

    activation.activated
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

  def json_show_slug
    return {} if @activation.nil?

    {
      params: params,
      code: @activation.code,
      result: @activation.activated
    }
  end

  def set_header
    response.set_header('Access-Control-Allow-Origin', '*')
  end

  def create_respond(format)
    if @activation.save
      format.html { redirect_to @activation, notice: 'Activation was successfully created.' }
      format.json { render :show, status: :created, location: @activation }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @activation.errors, status: :unprocessable_entity }
    end
  end

  def update_respond(format)
    if @activation.update(activation_params)
      format.html { redirect_to @activation, notice: 'Activation was successfully updated.' }
      format.json { render :show, status: :ok, location: @activation }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @activation.errors, status: :unprocessable_entity }
    end
  end
end
