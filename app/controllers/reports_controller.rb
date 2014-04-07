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
  
    @faculty_registrations = {}
    @openday.report_registrations.each do |name, registrations|
      data = {}
      registrations.each do |registration|
        data[registration.date] = registration.count
      end
      @faculty_registrations[name] = data
    end

    @openday_registrants = {}
    @openday.report_registrants.each do |registrant|
      @openday_registrants[registrant.date] = registrant.count
    end

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
      
      @programme_registrations = {}
      @openday_faculty.report_registrations.each do |name, registrations|
        data = {}
        registrations.each do |registration|
          data[registration.date] = registration.count
        end
        @programme_registrations[name] = data
      end

      @faculty_registrants = {}
      @openday_faculty.report_registrants.each do |registrant|
        @faculty_registrants[registrant.date] = registrant.count
      end

      @faculty_countries = @openday_faculty.report_countries
    end
  end

  def compare
    @openday_a = Openday.find_by_slug(params[:report_id])
    @openday_b = Openday.find_by_slug(params[:id])

    unless @openday_a
      @openday_a = Openday.find(params[:report_id])
    end

    unless @openday_b
      @openday_b = Openday.find(params[:id])
    end
  
    @faculty_registrations_a = {}
    @openday_a.report_registrations.each do |name, registrations|
      data = {}
      registrations.each do |registration|
        data[registration.date] = registration.count
      end
      @faculty_registrations_a[name] = data
    end

    @openday_registrants_a = {}
    @openday_a.report_registrants.each do |registrant|
      @openday_registrants_a[registrant.date] = registrant.count
    end

    @openday_countries_a = @openday_a.report_countries


    @faculty_registrations_b = {}
    @openday_b.report_registrations.each do |name, registrations|
      data = {}
      registrations.each do |registration|
        data[registration.date] = registration.count
      end
      @faculty_registrations_b[name] = data
    end

    @openday_registrants_b = {}
    @openday_b.report_registrants.each do |registrant|
      @openday_registrants_b[registrant.date] = registrant.count
    end

    @openday_countries_b = @openday_b.report_countries

    @openday_countries = Registrant.find(:all, 
      select: 'count(*) count, country', 
      group: 'country', 
      conditions: ['openday_id = ? OR openday_id = ?', @openday_a.id, @openday_b.id], 
      order: 'count DESC'
    )

  end
end