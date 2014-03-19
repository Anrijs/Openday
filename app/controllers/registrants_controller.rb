class RegistrantsController < ApplicationController
  def index
    @registrant = Registrant.new

    unless params[:openday]
      @openday = Openday.find_active
      if @openday.nil? or @openday.empty?
        @next_openday = Openday.where("registration_open >= ?", Time.now).order("registration_open ASC").first()
        render 'not_active'
      elsif @openday.length > 1
        render 'selection'
      else
        @openday = @openday.first
      end
    else
      @openday = Openday.find_by_slug(params[:openday])
      unless @openday.active?
        @next_openday = Openday.where("registration_open >= ?", Time.now).order("registration_open ASC").first()
        render 'not_active'
      end
    end
  end

  def create
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/svg_outputter'

    @openday = Openday.find(params[:openday_id])
    @registrant = Registrant.find_by_openday_id_and_email(@openday, params[:registrant]['email'])
    
    @recreated = false
    
    if @openday.active?
      @programmes = params[:programme]
      @registrant = Registrant.new(registrant_params)
      @registrant.openday_id = @openday.id
      if(@registrant.valid? and @programmes)
        if @registrant
          @registrant.destroy
          @recreated = true
        end
        @registrant.save
        @programmes.each do |programme, timeslot|
          prg = OpendayProgramme.find(programme)
          faculty = prg.openday_faculty.faculty.id
          Registration.create(registrant_id: @registrant.id, openday_id: @openday.id, 
                              faculty_id: faculty, programme_id: prg.programme.id, timeslot_id: timeslot)
        end
        @barcode = Barby::Code128B.new(@registrant.id)
        email = render_to_string  partial: '/email/index'
        pdf_text = render_to_string  partial: '/email/pdf'
        kit = PDFKit.new(pdf_text)
        # Get an inline PDF
        pdf = kit.to_pdf

        if Rails.env.development?
          Pony.mail(
            :from => 'tester@localhost',
            :to => 'ajargans@gmail.com',
            :subject => "[Test] "+t('mail.subject'),
            :html_body => email,
            :attachments => {"RegistrationCard.pdf" => pdf},
            :body_part_header => { content_disposition: "inline" }
          )
        else
          Pony.mail(
            :to => @registrant.email,
            :subject => t('mail.subject'),
            :html_body => email,
            :attachments => {"RegistrationCard.pdf" => pdf},
            :body_part_header => { content_disposition: "inline" }
          )
        end
        render 'create'
      else
      @registrant.check_programmes @programmes
        render 'index'  
      end
    end
  end

  def to_pdf
   render :pdf  => 'file_name'      
  end

private
  def registrant_params
    params.require(:registrant).permit(:name, :surname, :prefix, :email,
     :address1, :address2, :city, :state, :country, :postal_code, :year, :companions)
  end
end 