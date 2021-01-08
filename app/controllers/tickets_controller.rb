class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  after_action :send_to_cloud, only: [:create]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.all
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:title, :type, :order, :description, :duedate)
    end

    def send_to_cloud
      require 'uri'
      require 'net/http'
      require 'openssl'
  
      url = URI("https://cloud.pomocedlaseniora.pl/index.php/apps/deck/api/v1.0/boards/19/stacks/64/cards")
  
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
      request = Net::HTTP::Post.new(url)
      request["cookie"] = 'cookie_test=test; __cfduid=d6292f27c3efce1888584e264d708a8a61610100180; oc_sessionPassphrase=O4jje%252BSZrl67gXhX4OjOLhYRvRL%252FlG5vV90%252BROweNthuISxHuyWQOHEzt2jcQnj4RhaUmMQupmCoiMDBHHuhd64TaPbM24LE2OOvoKJ5LmVLYfEHz1U6ELYyjmhya2fD; __Host-nc_sameSiteCookielax=true; __Host-nc_sameSiteCookiestrict=true; oc1tynv43itb=a11917f36c74921c123fb0456f7c7509'
      request["content-type"] = 'application/json'
      request["ocs-apirequest"] = 'true'
      request["authorization"] = 'Basic cmVrbGFtYWNqZS1hcGk6ZmtqM3R6dFBUZzI2SGFG'
      request.body = "{\n\t\"title\": \"string\",\n\t\"type\": \"plain\",\n\t\"description\": \"Nowy string\",\n\t\"duedate\": \"2021-01-14\"\n}"
  
      response = http.request(request)
      puts response.read_body
    end
end
