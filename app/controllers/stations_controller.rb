class StationsController < ApplicationController
  before_action :set_station, only: [:show, :edit, :update, :destroy]

  # GET /stations
  # GET /stations.json
  def index
    @stations = if params[:term]
      Station.full_text_search(params[:term]).order(created_at: :desc).page
    else
      Station.order(created_at: :desc).page params[:page]
    end
  end

  # GET /stations/1
  # GET /stations/1.json
  def show
    @station = Station.find(params[:id])
    ActiveRecord::Base.default_timezone = :utc
    @mta = @station.sessions.group_by_hour_of_day(:created_at, format: "%l %P").count
    @this_week_entrances = @station.sessions
      .group_by_day(:created_at, format: "%d/%m", range: Date.today.at_beginning_of_week..Time.now).count.sum{|k,v| v}
    @last_month_entrances = @station.sessions
      .group_by_month(:created_at, format: "%B/%y", range: Date.today.at_beginning_of_month..Time.now).count.sum{|k,v| v}
    @last_year_entrances = @station.sessions
      .group_by_year(:created_at, format: "%Y", range: Date.today.at_beginning_of_year..Time.now).count.sum{|k,v| v}
    @all_time_entrances = @station.sessions.group_by_year(:created_at).count.sum {|k,v| v }
    respond_to do |format|
      format.html { render :show }
      format.json { render json: @station }
    end
  end

  # GET /stations/new
  def new
    @station = Station.new
  end

  # GET /stations/1/edit
  def edit
  end

  # POST /stations
  # POST /stations.json
  def create
    @station = Station.new(station_params)

    respond_to do |format|
      if @station.save
        format.html { redirect_to @station, notice: 'Station was successfully created.' }
        format.json { render :show, status: :created, location: @station }
      else
        format.html { render :new }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stations/1
  # PATCH/PUT /stations/1.json
  def update
    respond_to do |format|
      if @station.update(station_params)
        format.html { redirect_to @station, notice: 'Station was successfully updated.' }
        format.json { render :show, status: :ok, location: @station }
      else
        format.html { render :edit }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.json
  def destroy
    @station.destroy
    respond_to do |format|
      format.html { redirect_to stations_url, notice: 'Station was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /nowpresent
  # GET /nowpresent.json
  def nowpresent
    @stations = Station.present
    render json: @stations
  end

  # GET /anyone_here
  # GET /anyone_here.json
  def anyone_here?
    @res = Station.anyone_here?
    render json: @res
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_station
    @station = Station.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def station_params
    params.require(:station).permit(:name, :mac_addr, :last_seen, :ignore, :term, :is_female, :original_name)
  end
end
