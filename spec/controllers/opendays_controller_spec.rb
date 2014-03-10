require 'spec_helper'

describe OpendaysController do

  describe "GET 'index'" do
    context 'when user not logged in' do
      it "redirect to new session path" do
        get 'index'
        expect(response).to redirect_to new_admin_session_path
      end
    end

    context 'when user not logged in' do
      it "redirect to new session path" do
        sign_in FactoryGirl.create(:admin)
        get 'index'
        expect(response).to_not redirect_to new_admin_session_path
      end
    end
  end

  describe "GET 'new'" do
    before do
      sign_in FactoryGirl.create(:admin)
    end

    it "creates new object" do
      get 'new'
      expect(assigns(:openday)).to_not eq nil
    end
  end

  describe "POST 'create'" do
    before do
      sign_in FactoryGirl.create(:admin)
      @count = Openday.all.count
    end

    context 'when input not valid' do
      it "saves and redirects" do
        post 'create', name: 'Openday Test'
        expect(Openday.all.count == @count).to eq true
      end
    end

    context 'when input valid' do
      it "doesnt save" do
        post 'create', name: 'Openday Test', registration_open: "2014-02-03 17:00:00", registration_end: "2014-02-17 21:00:00", date: "2014-02-18"
        pry
        expect(response).to_not redirect_to opendays_path
        expect(Openday.all.count > @count).to eq true
      end
    end
  end

  describe "GET 'edit'" do
    before do
      sign_in FactoryGirl.create(:admin)
      @subject = FactoryGirl.create(:openday)
    end

    it "creates new object" do
      get 'edit', id: @subject.id
      expect(assigns(:openday)).to eq @subject
    end
  end

end
