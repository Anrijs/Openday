# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :openday_faculty, :class => 'OpendayFaculties' do
    faculty_id 1
    openday_id 1
  end
end
