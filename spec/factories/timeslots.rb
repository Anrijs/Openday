# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeslot do
    programme_id 1
    openday_id 1
    time_from "2014-02-13 17:20:49"
    time_till "2014-02-13 17:20:49"
    capacity 1
  end
end
