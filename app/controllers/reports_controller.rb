class ReportsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @opendays = Openday.all
  end

  def show
    @openday = Openday.find_by_slug(params[:id])
    unless @openday
      @openday = Openday.find(params[:id])
    end
  
    @faculty_registrations = @openday.report_registrations
    @openday_registrants = @openday.report_registrants
    @openday_countries = @openday.report_countries
  end

  def faculty
    @openday = Openday.find_by_slug(params[:report_id])
    unless @openday
      @openday = Openday.find(params[:report_id])
    end

    @faculty = Faculty.find_by_slug(params[:id])
    unless @faculty
      @faculty = Faculty.find_by_id(params[:id])
    end

    if @faculty.nil?
      redirect_to report_path(@openday)
    else
      @openday_faculty = @openday.openday_faculties.find_by_faculty_id(@faculty.id)
      @programme_registrations = @openday_faculty.report_registrations
      @faculty_registrants = @openday_faculty.report_registrants

      @openday_countries = @openday.report_countries
    end
  end
end