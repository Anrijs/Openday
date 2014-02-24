# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :openday_programme, :class => 'OpendayProgrammes' do
    faculty_id 1
    openday_id 1
  end
end
