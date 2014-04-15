class FacultiesController < ApplicationController
  # Require admin status to access this controlelr
  before_filter :authenticate_admin!

  # List all faculties
  def index
  	@faculties = Faculty.all
  end

  # Prepare new faculty
  def new
  	@faculty = Faculty.new
  end

  # Add new faculty
  def create
    @faculty = Faculty.new(faculty_params)
    if @faculty.save
    	flash[:success] = I18n.t('faculty.flash.create_success')
      redirect_to faculties_path
    else
    	flash[:error] = I18n.t('faculty.flash.create_error')
      render 'new'
    end
  end

  # Prepare faculty edit
  def edit
    @faculty = Faculty.find_by_slug(params[:id])
    @faculty = Faculty.find(params[:id]) if @faculty.nil?
  end

  # Update faculty
  def update
    @faculty = Faculty.find_by_slug(params[:id])
    @faculty = Faculty.find(params[:id]) if @faculty.nil?

    @faculty.update_attributes(faculty_params)
    if @faculty.save
      flash[:success] = t('faculty.flash.edit_success')
      redirect_to faculties_path
    else
      flash[:error] = t('faculty.flash.edit_error')
      render 'edit'
    end
  end

  # Delete faculty
  def destroy
  	@faculty = Faculty.find_by_slug(params[:id])
    @faculty = Faculty.find(params[:id]) if @faculty.nil?
    @faculty.destroy
    redirect_to faculties_path
  end

private
  def faculty_params
    params.require(:faculty).permit(:name, :short_name)
  end

end
