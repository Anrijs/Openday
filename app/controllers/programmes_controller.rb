class ProgrammesController < ApplicationController
  # Require admin status to access this controlelr
  #before_filter :authenticate_admin!

  # Prepare new programme
  def new
    @faculty = Faculty.find(params[:faculty_id])
  	@programme = @faculty.programmes.new
  end

  # Add new programme
  def create
    @programme = Programme.new(programme_params)
    if @programme.save
      flash[:success] = I18n.t('programme.flash.create_success')
      redirect_to faculties_path
    else
      flash[:error] = I18n.t('programme.flash.create_error')
      render 'new'
    end
  end

  # Prepare programme edit
  def edit   
    @programme = Programme.find_by_slug(params[:id])
    @programme = Programme.find(params[:id]) if @programme.nil?
  end

  # Update new programme
  def update
    @programme = Programme.find_by_slug(params[:id])
    @programme = Programme.find(params[:id]) if @programme.nil?

    @programme.update_attributes(programme_params)
    if @programme.save
      flash[:success] = t('programme.flash.edit_success')
      redirect_to faculties_path
    else
      flash[:error] = t('programme.flash.edit_error')
      render 'edit'
    end
  end

  # Delete programme
  def destroy
    @programme = Programme.find_by_slug(params[:id])
    @programme = Programme.find(params[:id]) if @programme.nil?

    @programme.destroy
    redirect_to faculties_path
  end

private
  def programme_params
    params.require(:programme).permit(:name, :faculty_id, :description, :url)
  end
end
