class OpendaysController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @opendays = Openday.all
    @faculties = Faculty.all
  end

  def new
    @openday = Openday.new
  end

  def create
    @openday = Openday.new openday_params
    if @openday.save
      flash[:success] = t('add_openday_success')
      unless ajax?
        redirect_to opendays_path
      end
    else
      flash[:error] = t('add_openday_failure')
      render 'new'
    end
  end

  def edit
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?
  end

  def update
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?

    @openday.update_attributes(openday_params)
    if @openday.save
      flash[:success] = t('edit_openday_success')
      redirect_to opendays_path
    else
      flash[:error] = t('edit_openday_failure')
      render 'edit'
    end

  end

  def destroy
    @openday = Openday.find_by_slug(params[:id])
    @openday = Openday.find(params[:id]) if @openday.nil?

    if @openday.destroy
      flash[:success] = t('delete_openday_success')
      redirect_to opendays_path
    else
      flash[:error] = t('delete__openday_failure')
      render 'edit'
    end
  end

private
  def openday_params
    params.require(:openday).permit(:name, :date, :registration_open, :registration_end)
  end

end
