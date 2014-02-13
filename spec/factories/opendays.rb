# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :openday do
    name "MyString"
    year 1
    registration_open "2014-02-13 17:16:44"
    registration_end "2014-02-13 17:16:44"
    date "2014-02-13"
  end
end
