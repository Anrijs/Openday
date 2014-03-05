class RegistrationsController < ApplicationController
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
end
