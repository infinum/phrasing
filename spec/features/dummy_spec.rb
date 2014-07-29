#encoding: utf-8
require 'spec_helper'

feature "use #phrase" do

  it "should see the header phrase" do
    visit root_path
    page.should have_content 'The Header'
  end

  it "should see the header phrase modified if created before visiting" do
    FactoryGirl.create(:phrasing_phrase, key: 'site.index.header', value: 'The Header1')
    visit root_path
    page.should have_content 'The Header1'
  end

  it "creates a phrasing_phrase if the yaml has an entry" do
    PhrasingPhrase.find_by_key('site.index.header').should be_nil
    visit root_path
    PhrasingPhrase.find_by_key('site.index.header').should_not be_nil
  end

  it "creates a phrasing_phrase if the yaml does not have an entry" do
    PhrasingPhrase.find_by_key('site.index.intro').should be_nil
    visit root_path
    PhrasingPhrase.find_by_key('site.index.intro').should_not be_nil
  end

  it "shows the phrasing_phrase instead of the yaml" do
    FactoryGirl.create(:phrasing_phrase, key: 'site.index.header', value: 'A different header')
    visit root_path
    page.should_not have_content 'The Header'
    page.should have_content 'A different header'
  end

  it "allows to treat every translation as html safe" do
    FactoryGirl.create(:phrasing_phrase, key: 'site.index.header', value: '<strong>Strong header</strong>')
    visit root_path
    page.should have_content 'Strong header'
    visit root_path
    page.should_not have_content '<strong>Strong header</strong>'
    page.should have_content 'Strong header'
  end

  it 'allows to use scope like I18n' do
    visit root_path
    page.should have_content 'models.errors.test'
    page.should have_content 'site.test'
  end
end

feature "locales" do

  it "displays different text based on users' locale" do
    FactoryGirl.create(:phrasing_phrase, locale: 'en', key: 'site.index.intro', value: 'world')
    FactoryGirl.create(:phrasing_phrase, locale: 'es', key: 'site.index.intro', value: 'mundo')

    I18n.locale = :en
    visit root_path
    page.should have_content 'world'
    page.should_not have_content 'mundo'

    I18n.locale = :es
    visit root_path
    page.should have_content 'mundo'
    page.should_not have_content 'world'

    I18n.locale = :fa
    visit root_path
    page.should_not have_content 'world'
    page.should_not have_content 'mundo'

    I18n.locale = :en  # reset
  end

end

feature "yaml" do

  describe 'on first visit value should be' do

    it "same as keys if there is no translation available" do
      visit root_path
      PhrasingPhrase.find_by_key('site.index.intro').value.should == 'site.index.intro'
    end

    it "same as translations in the yaml file if there is a translation available" do
      visit root_path
      PhrasingPhrase.find_by_key('site.index.header').value.should == 'The Header'
      PhrasingPhrase.find_by_key('site.index.footer').value.should == 'The Footer'
    end

  end
end