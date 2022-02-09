FactoryBot.define do
  factory :visit do
    data { "2022-02-08 11:11:05" }
    status { "MyString" }
    user { nil }
    checkin_at { "2022-02-08 11:11:05" }
    checkout_at { "2022-02-08 11:11:05" }
  end
end
