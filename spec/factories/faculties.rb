# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :faculty do
    name {"Faculty of #{rand(99999)}"}
    short_name {"Fox #{rand(99999)}"}
  end
end
