#encoding: utf-8
require 'spec_helper'

feature "use #phrase" do
  it "should see the header phrase" do
    visit root_path
    expect(page).to have_content('The Header')
  end

  it "should see the header phrase modified if created before visiting" do
    PhrasingPhrase.where(key: 'site.index.header').destroy_all
    FactoryGirl.create(:phrasing_phrase, key: 'site.index.header', value: 'The Header1')
    visit root_path
    expect(page).to have_content 'The Header1'
  end

  it "creates a phrasing_phrase if the yaml has an entry" do
    PhrasingPhrase.where(key: 'site.index.header').destroy_all
    expect(PhrasingPhrase.find_by_key('site.index.header')).to be_nil
    visit root_path
    expect(PhrasingPhrase.find_by_key('site.index.header')).not_to be_nil
  end

  it "creates a phrasing_phrase if the yaml does not have an entry" do
    PhrasingPhrase.where(key: 'site.index.intro').destroy_all
    expect(PhrasingPhrase.find_by_key('site.index.intro')).to be_nil
    visit root_path
    expect(PhrasingPhrase.find_by_key('site.index.intro')).not_to be_nil
  end

  it "shows the phrasing_phrase instead of the yaml" do
    PhrasingPhrase.where(key: 'site.index.header').destroy_all
    FactoryGirl.create(:phrasing_phrase, key: 'site.index.header', value: 'A different header')
    visit root_path
    expect(page).not_to have_content 'The Header'
    expect(page).to have_content 'A different header'
  end

  it "allows to treat every translation as html safe" do
    PhrasingPhrase.where(key: 'site.index.header').destroy_all
    FactoryGirl.create(:phrasing_phrase, key: 'site.index.header', value: '<strong>Strong header</strong>')
    visit root_path
    expect(page).to have_content 'Strong header'
    visit root_path
    expect(page).not_to have_content '<strong>Strong header</strong>'
    expect(page).to have_content 'Strong header'
  end

  it 'allows to use scope like I18n' do
    visit root_path
    expect(page).to have_content 'models.errors.test'
    expect(page).to have_content 'site.test'
  end

  context 'preventing link redirects', js: true do
    context 'edit mode is enabled' do
      it 'should prevent phrasing link redirects' do
        visit root_path
        find('#phrasing-onoffswitch').click
        click_link 'Editable link'
        expect(page).not_to have_content 'Example page for phrasing'
        expect(page).to have_content 'Editable link'
      end

      it 'should not prevent other link redirects' do
        visit root_path
        click_link 'Uneditable link'
        expect(page).to have_content 'Example page for phrasing'
        expect(page).not_to have_content 'Editable link'
      end

      it 'should not prevent the phrasing edit all phrases link' do
        visit root_path
        find('#phrasing-edit-all-phrases-icon-container').click
        expect(page).to have_content 'Phrasing'
      end
    end

    context 'edit mode is disabled' do
      it 'should not prevent link redirects' do
        visit root_path
        click_link 'Editable link'
        expect(page).to have_content 'Example page for phrasing'
        expect(page).not_to have_content 'Editable link'
      end
    end
  end
end

feature "locales" do
  before do
    PhrasingPhrase.destroy_all
  end

  it "displays different text based on users' locale" do
    FactoryGirl.create(:phrasing_phrase, locale: 'en', key: 'site.index.intro', value: 'world')
    FactoryGirl.create(:phrasing_phrase, locale: 'es', key: 'site.index.intro', value: 'mundo')

    I18n.locale = :en
    visit root_path
    expect(page).to     have_content 'world'
    expect(page).not_to have_content 'mundo'

    I18n.locale = :es
    visit root_path
    expect(page).to     have_content 'mundo'
    expect(page).not_to have_content 'world'

    I18n.locale = :fa
    visit root_path
    expect(page).not_to have_content 'world'
    expect(page).not_to have_content 'mundo'

    I18n.locale = :en # reset
  end

end

feature "yaml" do

  describe 'on first visit' do

    it "value should be the same as keys if there is no translation available" do
      visit root_path
      expect(PhrasingPhrase.find_by_key('site.index.intro').value).to eq('site.index.intro')
    end

    it "same as translations in the yaml file if there is a translation available" do
      visit root_path
      expect(PhrasingPhrase.find_by_key('site.index.header').value).to eq('The Header')
    end

    it "if using I18n.t(), there shouldn't be a new PhrasingPhrase record." do
      visit root_path
      expect(PhrasingPhrase.find_by_key('site.index.footer')).to be_nil
    end
  end
end
