class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = Session.all
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
    @session = Session.new
  end

  # GET /sessions/1/edit
  def edit
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = Session.new(session_params)

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully created.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session.destroy
    respond_to do |format|
      format.html { redirect_to sessions_url, notice: 'Session was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def timeline
    params[:day_to_display].nil? ? @sessions = Session.today : @sessions = Session.by_day(params[:day_to_display])
    slides = []
    @sessions.each do |s|
      name = s.station.name.nil? ? s.station.mac_addr : s.station.name
      endingDate = s.end.nil? ? Time.now : s.end
      slides.push({
        :startDate => s.start,
        :endDate => endingDate,
        :headline => name,
        :text => "Rilevata presenza di: #{name} il #{DateTime.parse("#{s.start.to_s}").strftime('%a %b %d %Y at %H:%M:%S') }"
        })
      end

      respond_to do |format|
        msg = {
          :headline => "Sessions Timeline",
          :type => "default",
          :text => "All the sessions for #{DateTime.parse("#{@sessions.first.start.to_s}").strftime('%a %b %d %Y')}",
          :startDate => @sessions.first.start,
          :date => slides
        }
        format.json  { render :json => {:timeline => msg} }
      end
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_session
    @session = Session.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:start, :end, :duration, :open, :station_id)
  end
