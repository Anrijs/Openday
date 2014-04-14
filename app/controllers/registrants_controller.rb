class RegistrantsController < ApplicationController
  caches_page :index
  # Prepare registration forms
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

  # Process registration
  def create
    require 'barby'
    require 'barby/barcode/code_128'
    require 'barby/outputter/svg_outputter'
    
    # Check if registrant already registred before
    @openday = Openday.find(params[:openday_id])
    @registrant = Registrant.find_by_openday_id_and_email(@openday, params[:registrant]['email'])
    @recreated = false

    unless @registrant.nil?
      if(@registrant.valid? and @programmes and params[:confirm_terms])
        if @registrant
          @registrant.destroy
          @recreated = true
        end
      end
    else
      @registrant = Registrant.new(registrant_params)
    end
    
    if @openday.active?
      @programmes = params[:programme]
      @registrant.openday_id = @openday.id
      if(@registrant.valid? and @programmes and params[:confirm_terms])
        @registrant.save
        @programmes.each do |programme, timeslot|
          prg = OpendayProgramme.find(programme)
          faculty = prg.openday_faculty.faculty.id
          Registration.create(registrant_id: @registrant.id, openday_id: @openday.id, 
                              faculty_id: faculty, programme_id: prg.programme.id, timeslot_id: timeslot)
        end

        # Generate barcode for registration card
        @barcode = Barby::Code128B.new(@registrant.id)
        email = render_to_string  partial: '/email/index'
        pdf_text = render_to_string  partial: '/email/pdf'
        MailWorker.perform_async(pdf_text, email, @registrant.email, I18n.t('mail.subject'))

        # Prepare and send confirmation email
        render 'create'
      else
        unless params[:confirm_terms]
          @registrant.errors.add(:confirmation, I18n.t('validation.confirmation_ressence'))
        end
        @registrant.check_programmes @programmes
        render 'index'  
      end
    end
  end

  # Terms page (no data procesing required)
  def terms
  end

  # Create pdf file
  def to_pdf
   render :pdf  => 'file_name'      
  end

private
  def registrant_params
    params.require(:registrant).permit(:name, :surname, :prefix, :email,
     :address1, :address2, :city, :state, :country, :postal_code, :year, :companions)
  end
end 