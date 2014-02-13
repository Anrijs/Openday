# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :registrant do
    name "MyString"
    prefix "MyString"
    surname "MyString"
    email "MyString"
    address1 "MyString"
    address2 "MyString"
    city "MyString"
    state "MyString"
    country "MyString"
    postal_code "MyString"
    year 1
  end
end
