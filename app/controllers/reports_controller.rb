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

      @faculty_timeslots = @openday_faculty.report_timeslots
    end
  end

  def compare
    if(params[:id].to_s == "0")
      redirect_to report_path(params[:report_id])
      return
    end

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

  def compare_faculty
    if(params[:compare_id].to_s == "0")
      redirect_to report_faculty_path(params[:report_id], params[:id])
      return
    end

    @openday_a = Openday.find_by_slug(params[:report_id])
    unless @openday_a
      @openday_a = Openday.find(params[:report_id])
    end

    @openday_b = Openday.find_by_slug(params[:compare_id])
    unless @openday_b
      @openday_b = Openday.find(params[:compare_id])
    end

    @faculty = Faculty.find_by_slug(params[:id])
    unless @faculty
      @faculty = Faculty.find_by_id(params[:id])
    end

    if @faculty.nil?
      redirect_to report_path(@openday_a)
    else
      @openday_faculty_a = @openday_a.openday_faculties.find_by_faculty_id(@faculty.id)
      @openday_faculty_b = @openday_b.openday_faculties.find_by_faculty_id(@faculty.id)

      if (@openday_faculty_b.nil? or @openday_faculty_a.nil?)
        render 'compare_faculty_error'
        return
      end

      @programme_registrations_a = {}
      @openday_faculty_a.report_registrations.each do |name, registrations|
        data = {}
        registrations.each do |registration|
          data[registration.date] = registration.count
        end
        @programme_registrations_a[name] = data
      end

      @programme_registrations_b = {}
      @openday_faculty_b.report_registrations.each do |name, registrations|
        data = {}
        registrations.each do |registration|
          data[registration.date] = registration.count
        end
        @programme_registrations_b[name] = data
      end

      @faculty_registrants_a = {}
      @openday_faculty_a.report_registrants.each do |registrant|
        @faculty_registrants_a[registrant.date] = registrant.count
      end

      @faculty_registrants_b = {}
      @openday_faculty_b.report_registrants.each do |registrant|
        @faculty_registrants_b[registrant.date] = registrant.count
      end

      @faculty_countries_a = @openday_faculty_a.report_countries
      @faculty_countries_b = @openday_faculty_b.report_countries

      @openday_countries = Registrant.find(:all, 
      select: 'count(*) count, country', 
      group: 'country', 
      conditions: ['openday_id = ? OR openday_id = ?', @openday_a.id, @openday_b.id], 
      order: 'count DESC'
    )
    end
  end
end