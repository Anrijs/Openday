require 'spec_helper'

describe Faculty do
  describe "relations" do
    it {should have_many(:programmes)}
    it {should have_many(:openday_faculties)}
  end

  describe "validations" do
    it {should validate_presence_of(:name).with_message(I18n.t('validation.name_presence'))}
    it {should validate_presence_of(:short_name).with_message(I18n.t('validation.short_name_presence'))}

    it {should validate_uniqueness_of(:name).with_message(I18n.t('validation.name_uniqueness'))}
    it {should validate_uniqueness_of(:short_name).with_message(I18n.t('validation.short_name_uniqueness'))}
  end

  describe "#create_slug" do
    context 'when new record created' do
      it "generates slug" do
      	@faculty = FactoryGirl.create(:faculty, short_name: "T &e st  ")
      	expect(@faculty.slug).to eq('t-e-st')
      end
    end

    context 'when slug already in use' do
      it "does not validate" do
        FactoryGirl.create(:faculty, short_name: "T &e st  ")
        @faculty = FactoryGirl.build(:faculty, short_name: "t E St")
        expect(@faculty.valid?).to eq(false)
      end
    end
  end
end