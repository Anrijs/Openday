class OpendaysController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @opendays = Openday.all
    @faculties = Faculty.all
  end

  def new
    @openday = Openday.new
  end

  def create
    @openday = Openday.new openday_params
    if @openday.save
      flash[:success] = t('add_openday_success')
    else
      flash[:error] = t('add_openday_failure')
      render 'new'
    end
  end

  def edit
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?
  end

  def update
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?

    @openday.update_attributes(openday_params)
    if @openday.save
      flash[:success] = t('edit_openday_success')
      redirect_to opendays_path
    else
      flash[:error] = t('edit_openday_failure')
      render 'edit'
    end

  end

  def destroy
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?

    if @openday.destroy
      flash[:success] = t('delete_openday_success')
      redirect_to opendays_path
    else
      flash[:error] = t('delete__openday_failure')
      render 'edit'
    end
  end

  def faculties
    @faculties = Faculty.all
    @active_faculties = {}
    Openday.find(params[:openday_id]).openday_faculties.each do |faculty|
      @active_faculties[faculty.faculty_id] = '1'
    end
  end

  def add_faculties
    faculties = Faculty.all
    openday = Openday.find(params[:openday_id])
    get_faculties = {}
    get_faculties = params[:faculty] unless params[:faculty].nil?

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

  def programmes
    @programmes = Faculty.find(params[:id]).programmes
    @active_programmes = {}
    Openday.find(params[:openday_id]).openday_programmes.each do |programme|
      @active_programmes[programme.programme_id] = '1'
    end
    pry
  end

  def add_programmes
    pry
    programmes = Faculty.find(params[:faculty_id]).programmes
    openday = Openday.find(params[:openday_id])
    get_programmes = {}
    get_programmes = params[:programme] unless params[:programme].nil?

    programmes.each do |programme|
      if get_programmes.has_key?(programme.id.to_s)
        unless OpendayProgramme.exists?(programme_id: programme.id, openday_id: openday.id)
          programme = OpendayProgramme.new(programme_id: programme.id, openday_id: openday.id)
          programme.save
        end
      else
        if OpendayProgramme.exists?(programme_id: programme.id, openday_id: openday.id)
          programme = OpendayProgramme.find_by(programme_id: programme.id, openday_id: openday.id)
          programme.destroy
        end
      end
    end
    redirect_to opendays_path
  end

private
  def openday_params
    params.require(:openday).permit(:name, :date, :registration_open, :registration_end)
  end

end
