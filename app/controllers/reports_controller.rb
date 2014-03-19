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

    @faculty_registrations = {}
    
    @openday.openday_faculties.each do |faculty|   
      time_array = []
      registrations = Registration.where('faculty_id LIKE ? and openday_id LIKE ?', faculty.faculty.id, @openday.id)
      (start_date..end_date).each do |day|
        unless DateTime.now < day
          time_array.push registrations.where(
            "created_at >= ? AND created_at < ?",
                day.beginning_of_day, day.end_of_day).count
        else
          time_array.push(nil)
        end
      end
      @faculty_registrations[faculty.id] = time_array
    end

    @openday_range = []
    @openday_registrations = []

    registrants = @openday.registrants
    (start_date..end_date).each do |day|
      @openday_range.push("#{day.strftime('%b %d')}")
      unless DateTime.now < day
        @openday_registrations.push registrants.where(
          "created_at >= ? AND created_at < ?",
              day.beginning_of_day, day.end_of_day).count
      else
        @openday_registrations.push(nil)
      end
    end

    @openday_countries = {}
    Country.all.each do |country|
      #arr = [country.first, registrants.where('country LIKE ?', country.last).count]
      @openday_countries[country.last] = registrants.where('country LIKE ?', country.last).count
    end
    @openday_countries = (@openday_countries.sort_by { |name, count| count }).reverse
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
    
    @openday_faculty.openday_programmes.each do |programme|   
      time_array = []
      registrations = Registration.where('programme_id LIKE ? and openday_id LIKE ?', programme.programme.id, @openday.id)
      (start_date..end_date).each do |day|
        unless DateTime.now < day
          time_array.push registrations.where(
            "created_at >= ? AND created_at < ?",
                day.beginning_of_day, day.end_of_day).count
        else
          time_array.push(nil)
        end
      end
      @programme_registrations[programme.id] = time_array
    end

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