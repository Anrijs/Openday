# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :openday do
    name "MyString"
    year 1
    registration_open "2014-02-03 17:00:00"
    registration_end "2014-02-17 21:00:00"
    date "2014-02-18"
  end
end
