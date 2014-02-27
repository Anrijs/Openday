# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :programme do
    name {"Programme ##{rand(99999)}"}
    faculty_id {rand(99999)}
  end
end