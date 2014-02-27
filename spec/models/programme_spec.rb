require 'spec_helper'

describe Programme do
  describe "relations" do
    it {should belong_to(:faculty)}
    it {should have_many(:openday_programmes)}
  end

  describe "validations" do
    it {should validate_presence_of(:name).with_message(I18n.t('validation.name_presence'))}

    context "when name in not unique for same faculty" do
      it "returns error" do
        pending "needs implementation"
      end
    end

    context "when name same as other from different faculty" do
      it "does not return error" do
        pending "needs implementation"
      end
    end
  end

  describe "#create_slug" do
    before do
      @faculty = FactoryGirl.create(:faculty)
    end

    context 'when new record created' do
      it "generates slug" do
      	@programme = FactoryGirl.create(:programme, name: 'Pro & gramme', faculty_id: @faculty.id)
        expect(@programme.slug).to eq('pro-gramme')
      end
    end

    context 'when slug already in use' do
      it "does not validate" do
        pending "needs implementation"
        FactoryGirl.create(:programme, name: 'Pro & gramme', faculty_id: @faculty.id)
      	@programme = FactoryGirl.create(:programme, name: 'Pro - Gramme', faculty_id: @faculty.id)
        expect(@programme.valid?).to eq(false)
      end
    end
  end
end