class FacultiesController < ApplicationController
  before_filter :authenticate_admin!

  def index
  	@faculties = Faculty.all
  end

  def new
  	@faculty = Faculty.new
  end

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

  def edit
    @faculty = Faculty.find_by_slug(params[:id])
    @faculty = Faculty.find(params[:id]) if @faculty.nil?
  end

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
