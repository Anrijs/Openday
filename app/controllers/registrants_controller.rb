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
    @openday = Openday.find(params[:openday_id])
    @registrant = Registrant.find_by_openday_id_and_email(@openday, params[:registrant]['email'])
    
    if @registrant
      @registrant.destroy
    end
    
    if @openday.active?
      programmes = params[:programme]
      @registrant = Registrant.new(registrant_params)
      @registrant.openday_id = @openday.id
      @registrant.save
      if(@registrant.valid?)
        programmes.each do |key, programme|
          Registration.create(registrant_id: @registrant.id, openday_id: @openday.id, timeslot_id: programme)
        end
      else
        @registrant.check_programmes programmes
        render 'index'  
      end
    end
  end

private
  def registrant_params
    params.require(:registrant).permit(:name, :surname, :prefix, :email,
     :address1, :address2, :city, :state, :country, :postal_code, :year, :companions)
  end
end 