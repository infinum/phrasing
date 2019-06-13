FactoryBot.define do
  sequence :string do |n|
    "string%09d" % n
  end

  factory :phrasing_phrase do
    key { FactoryBot.generate(:string) }
    value { FactoryBot.generate(:string) }
    locale { I18n.default_locale }
  end
end
