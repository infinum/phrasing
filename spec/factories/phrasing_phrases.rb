FactoryGirl.define do
  sequence :string do |n|
    "string%09d" % n
  end
  
  factory :phrasing_phrase do
    key { FactoryGirl.generate(:string) }
    value { FactoryGirl.generate(:string) }
    locale I18n.default_locale
  end
end

