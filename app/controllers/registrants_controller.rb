class RegistrantsController < ApplicationController
  def create
    render 'params'
    #find by obenday and email if exists in db
       #TODO
    #if exists ask and update, delete all old registrations
      #TODO
    #else create new

    @openday = Openday.find(params[:openday_id])

    if @openday.active?
      @registrant = Registrant.new(registrant_params)
      @registrant.save
  
      programmes = params[:programme]
      programmes.each do |key, programme|
        Registration.create(registrant_id: @registrant.id, openday_id: @openday.id, timeslot_id: programme)
      end
    end
  end

private
  def registrant_params
    params.require(:registrant).permit(:name, :surname, :prefix, :email,
     :address1, :address2, :city, :state, :country, :postal_code, :year)
  end
end