class FacultiesController < ApplicationController
  def index
  	@faculties = Faculty.all
  end

  def new
  	@faculty = Faculty.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @faculty = Faculty.new(faculty_params)
    if @faculty.save
    	flash[:success] = I18n.t('create_faculty_success')
      redirect_to faculties_path
    else
    	flash[:error] = I18n.t('create_faculty_error')
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
      flash[:success] = t('edit_faculty_success')
      redirect_to faculties_path
    else
      flash[:error] = t('edit_faculty_error')
      render 'edit'
    end
  end

  def destroy
  	@faculty = Faculty.find_by_slug(params[:id])
    @faculty = Faculty.find(params[:id]) if @faculty.nil?

    @faculty.delete
    redirect_to faculties_path
  end

private
  def faculty_params
    params.require(:faculty).permit(:name, :short_name)
  end

end
