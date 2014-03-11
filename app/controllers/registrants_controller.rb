class RegistrantsController < ApplicationController
  def index

    @registrant = Registrant.new
    unless params[:openday]
      @openday = Openday.find_active
  
      if @openday.nil?
        render 'not_active'
      elsif @openday.length > 1
        render 'selection'
      else
        @openday = @openday.first
      end
    else
      @openday = Openday.find_by_slug(params[:openday])
      unless @openday.active?
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
    if @registrant
      @registrant.destroy
      @recreated = true
    end
    
    if @openday.active?
      @programmes = params[:programme]
      @registrant = Registrant.new(registrant_params)
      @registrant.openday_id = @openday.id
      if(@registrant.valid? and @programmes)
        @registrant.save
        @programmes.each do |key, programme|
          Registration.create(registrant_id: @registrant.id, openday_id: @openday.id, timeslot_id: programme)
        end
        @barcode = Barby::Code128B.new(@registrant.id)
        email = render_to_string  partial: '/email/index'
        pdf_text = render_to_string  partial: '/email/pdf'
        kit = PDFKit.new(pdf_text)
        # Get an inline PDF
        pdf = kit.to_pdf

        Pony.mail(
          :to => @registrant.email,
          :subject => t('mail.subject'),
          :body => 'test',
          :html_body => email,
          :attachments => {"foo.pdf" => pdf},
          :body_part_header => { content_disposition: "inline" }
        )
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