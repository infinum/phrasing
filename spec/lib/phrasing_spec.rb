require 'spec_helper'

describe Phrasing do

  let(:Base) do
    Class.new.tap do |b|
      b.class_eval do
        module SimpleImplementation
          def lookup(*args)
            "translation missing"
          end
        end
        include SimpleImplementation
      end
    end
  end

  let(:base) do
    Base().new
  end

  before do
    Base().class_eval do
      include Phrasing::Implementation
    end
  end

  describe ".lookup" do
    it "returns simple lookup if phrasing_phrase missing" do
      base.lookup(nil, '').should == "translation missing"
    end

    it "returns phrasing_phrase if present" do
      cct = FactoryGirl.create(:phrasing_phrase)
      base.lookup(cct.locale, cct.key).should == cct.value
    end

    it "creates phrasing_phrase if one is missing" do
      PhrasingPhrase.where(locale: 'en', key: 'foo').should be_empty
      base.lookup('en', 'foo')
      PhrasingPhrase.where(locale: 'en', key: 'foo').should_not be_empty
    end

    it "creates scoped phrasing_phrase if one is missing" do
      PhrasingPhrase.where(locale: 'en', key: 'the_scope.foo').should be_empty
      base.lookup('en', 'foo', :"the_scope")
      PhrasingPhrase.where(locale: 'en', key: 'the_scope.foo').should_not be_empty
    end
  end
end
