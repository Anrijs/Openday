class OpendaysController < ApplicationController
  # Require admin status to access this controlelr
  #before_filter :authenticate_admin!
  caches_page :index, :new

  # Show openday list
  def index
    @opendays = {}.to_json
    @opendays = Openday.includes({:openday_faculties => :openday_programmes}).order('date DESC')
    @opendays.each do |openday|
      openday.openday_faculties.each do |faculty|
        faculty.openday_programmes.each do |programme|
          programme.openday_timeslots = programme.openday_timeslots
        end
      end
    end
    @faculties = Faculty.all
  end

  # Prepare new openday
  def new
    @openday = Openday.new
  end

  # Add new openday
  def create
    @openday = Openday.new openday_params
    if @openday.save
      flash[:success] = I18n.t('openday.flash.create_success')
      redirect_to opendays_path
    else
      flash[:error] = I18n.t('openday.flash.create_error')
      render 'new'
    end
  end

  # Prepare openday edit
  def edit
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?
  end

  # Update programme
  def update
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?

    @openday.update_attributes(openday_params)
    if @openday.save
      flash[:success] = I18n.t('openday.flash.edit_success')
      redirect_to opendays_path
    else
      flash[:error] = I18n.t('openday.flash.edit_error')
      render 'edit'
    end
  end

  # Delete programme
  def destroy
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?

    if @openday.destroy
      flash[:success] = I18n.t('openday.flash.delete_success')
      redirect_to opendays_path
    else
      flash[:error] = I18n.t('openday.flash.delete_error')
      render 'edit'
    end
  end

  # Get all faculties of openday
  def faculties
    @faculties = Faculty.all
    @active_faculties = {}
    Openday.find(params[:openday_id]).openday_faculties.each do |faculty|
      @active_faculties[faculty.faculty_id] = '1'
    end
  end

  # Add programmes to openday
  def add_faculties
    faculties = Faculty.all
    openday = Openday.find(params[:openday_id])
    get_faculties = {}
    get_faculties = params[:faculty] unless params[:faculty].nil?

    # Process post data and add or remove selected faculties
    faculties.each do |faculty|
      if get_faculties.has_key?(faculty.id.to_s)
        unless OpendayFaculty.exists?(faculty_id: faculty.id, openday_id: openday.id)
          faculty = OpendayFaculty.new(faculty_id: faculty.id, openday_id: openday.id)
          faculty.save
        end
      else
        if OpendayFaculty.exists?(faculty_id: faculty.id, openday_id: openday.id)
          faculty = OpendayFaculty.find_by(faculty_id: faculty.id, openday_id: openday.id)
          faculty.destroy
        end
      end
    end
    redirect_to opendays_path
  end

  # Get all openday faculty programmes
  def programmes
    faculty = Openday.find(params[:openday_id]).openday_faculties.find(params[:id])
    @programmes = Faculty.find(faculty.faculty_id).programmes
    @active_programmes = {}
    faculty.openday_programmes.each do |programme|
      @active_programmes[programme.programme_id] = '1'
    end
  end

  # Process post data and add or remove selected programmes
  def add_programmes
    openday = Openday.find(params[:openday_id])
    faculty = openday.openday_faculties.find(params[:faculty_id])
    programmes = Faculty.find(faculty.faculty_id).programmes.all

    get_programmes = {}
    get_programmes = params[:programme] unless params[:programme].nil?

    programmes.each do |programme|
      if get_programmes.has_key?(programme.id.to_s)
        unless OpendayProgramme.exists?(programme_id: programme.id, openday_faculty_id: faculty.id)
          programme = OpendayProgramme.new(programme_id: programme.id, openday_faculty_id: faculty.id)
          programme.save
        end
      else
        if OpendayProgramme.exists?(programme_id: programme.id, openday_faculty_id: faculty.id)
          programme = OpendayProgramme.find_by(programme_id: programme.id, openday_faculty_id: faculty.id)
          programme.destroy
        end
      end
    end
    redirect_to opendays_path
  end

  # Get all openday programme timeslots
  def timeslots 
    programme = OpendayProgramme.find(params[:id])
    @timeslot = programme.openday_timeslots.new
  end

  # Add timeslot to openday programme
  def add_timeslots 
    programme = OpendayProgramme.find(params[:id])
    @timeslot = programme.openday_timeslots.new(timeslot_params)
    if @timeslot.save
      redirect_to opendays_path
    else 
      raise ArgumentError
    end
  end

  # Prepare openday programme timeslot edit
  def edit_timeslots
    @timeslot = OpendayTimeslot.find(params[:id])
  end

  # Update openday programme timeslot
  def update_timeslots
    @timeslot = OpendayTimeslot.find(params[:id])
    @timeslot.update_attributes(timeslot_params)
    if @timeslot.save
      redirect_to opendays_path
    else 
      raise ArgumentError
    end
  end

private
  def openday_params
    params.require(:openday).permit(:name, :date, :registration_open, :registration_end)
  end

  def timeslot_params
    params.require(:openday_timeslot).permit(:time_from, :time_till, :capacity)
  end
end