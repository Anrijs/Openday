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

    start_date = DateTime.parse(@openday.registration_open.to_s)
    end_date = DateTime.parse(@openday.registration_end.to_s)

    @faculty_registrations = @openday.report_registrations
    @openday_registrants = @openday.report_registrants
    @openday_countries = @openday.report_countries
    @openday_range = []
  end

  def faculty
    @openday = Openday.find_by_slug(params[:report_id])
    unless @openday
      @openday = Openday.find(params[:report_id])
    end

    start_date = DateTime.parse(@openday.registration_open.to_s)
    end_date = DateTime.parse(@openday.registration_end.to_s)

    @faculty = Faculty.find_by_slug(params[:id])
    unless @openday
      @faculty = Faculty.find(params[:id])
    end

    @openday_faculty = @openday.openday_faculties.find_by_faculty_id(@faculty.id)

    @programme_registrations = {}
    
    @openday_range = []
    @openday_registrations = []

    registrations = @openday.registrations.where('faculty_id LIKE ?', @openday_faculty.faculty.id).select('DISTINCT(registrant_id)')
    (start_date..end_date).each do |day|
      @openday_range.push("#{day.strftime('%b %d')}")
      unless DateTime.now < day
        @openday_registrations.push registrations.where(
          "created_at >= ? AND created_at < ?",
              day.beginning_of_day, day.end_of_day).count
      else
        @openday_registrations.push(nil)
      end
    end

    registrants = @openday.registrants
    @openday_countries = {}

    registrations.each do |registration|
      if @openday_countries[registration.registrant.country].nil?
        @openday_countries[registration.registrant.country] = 0
      end
      @openday_countries[registration.registrant.country] = @openday_countries[registration.registrant.country] + 1
    end

    @openday_countries = (@openday_countries.sort_by { |name, count| count }).reverse
  end
end