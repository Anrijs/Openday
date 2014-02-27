require 'spec_helper'

describe Openday do
  describe "relations" do
    it {should have_many(:openday_faculties)}
  end

  describe "validations" do
    it {should validate_presence_of(:name).with_message(I18n.t('validation.name_presence'))}
    it {should validate_uniqueness_of(:name).with_message(I18n.t('validation.name_uniqueness'))}
  end

  describe "#create_slug" do
    context 'when new record created' do
      it "generates slug" do
      	@openday = FactoryGirl.create(:openday, name: "T &e st  ")
      	expect(@openday.slug).to eq('t-e-st')
      end
    end

    context 'when slug already in use' do
      it "does not validate" do
        FactoryGirl.create(:openday, name: "T &e st  ")
        @openday = FactoryGirl.build(:openday, name: "t E St")
        expect(@openday.valid?).to eq(false)
      end
    end
  end

end