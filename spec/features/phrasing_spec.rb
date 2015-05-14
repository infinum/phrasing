#encoding: utf-8
require 'spec_helper'

feature 'edit mode bubble' do

  before do
    visit root_path
  end

  it '(un)check edit mode checkbox' do
    edit_mode_checkbox = find(:css, ".onoffswitch-checkbox")
    expect(edit_mode_checkbox).to be_checked
    edit_mode_checkbox.set(false)
    expect(edit_mode_checkbox).not_to be_checked
  end

  it "phrases initially shouldn't have class 'phrasable-on' and contenteditable=true" do
    expect(page.find('.header').first('.phrasable').text).to eq 'The Header'
    expect(page.find('.header').first('.phrasable')['class']).to eq 'phrasable'
    expect(page.find('.header').first('.phrasable')['contenteditable']).to be_nil
  end

  it 'should be able to visit phrasing index via edit_all icon' do
    find(:css, ".phrasing-edit-all-phrases-link").click
    expect(current_path).to eq phrasing_phrases_path
  end

  xit "phrases should have class shouldn't have class phrasable on when edit mode is off", js: true do
    edit_mode_checkbox = find(:css, ".onoffswitch-checkbox")
    edit_mode_checkbox.click
    expect(page.find('.header').first('.phrasable')['class']).to eq 'phrasable'
  end

  xit 'edit phrases', js: true do
    header_phrase = page.find('.header').first('.phrasable')
    header_phrase['class'].should eq 'phrasable phrasable_on'
    expect(header_phrase.text).to eq 'The Header'
    header_phrase.set "content"
    expect(header_phrase.expect.text).to eq 'content'
  end
end

feature "phrasing index" do

  before do
    FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar")
    visit phrasing_phrases_path
  end

  it "has a nav bar" do
    click_link 'Import / Export'
    click_link 'Help'
    click_link 'Phrases'
  end

  it " shows phrases" do
    expect(page).to have_content 'foo'
    expect(page).to have_content 'bar'
  end

  it "allows search by key" do
    fill_in 'search', with: 'foo'
    click_button 'Search'
    expect(page).to have_content 'foo'
    expect(page).to have_content 'bar'
  end

  it "allows search by key" do
    fill_in 'search', with: 'xfoo'
    click_button 'Search'
    expect(page).not_to have_content 'foo'
    expect(page).not_to have_content 'bar'
  end

  it "allows search by value" do
    fill_in 'search', with: 'bar'
    click_button 'Search'
    expect(page).to have_content 'foo'
    expect(page).to have_content 'bar'
  end

  it "allows search by value" do
    fill_in 'search', with: 'xbar'
    click_button 'Search'
    expect(page).not_to have_content 'foo'
    expect(page).not_to have_content 'bar'
  end

  it "searches in the middles of strings" do
    FactoryGirl.create(:phrasing_phrase, key: "site.index.something")
    fill_in 'search', with: 'index'
    click_button 'Search'
    expect(page).to have_content 'site.index.something'
  end

  it "can show all" do
    FactoryGirl.create(:phrasing_phrase, key: "foe", value: "beer")
    click_button 'Search'
    expect(page).to have_content 'foo'
    expect(page).to have_content 'foe'
  end

  it 'not null values first, global order by key' do
    FactoryGirl.create(:phrasing_phrase, key: "foo1", value: nil)
    FactoryGirl.create(:phrasing_phrase, key: "foo2", value: "beer")
    FactoryGirl.create(:phrasing_phrase, key: "foo3", value: nil)
    visit phrasing_phrases_path
    expect(page.body).to match /foo[\s\S]*foo2[\s\S]*foo1[\s\S]*foo3/
  end

  context "more than one locale" do

    before do
      PhrasingPhrase.destroy_all
      FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar1", locale: "en")
      FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar2", locale: "fa")
      FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar3", locale: "it")
    end

    it "nil locale, blank search" do
      # impossible for user to replicate this case
      visit phrasing_phrases_path('search' => '', 'commit' => 'Search')
      expect(page).to have_content 'bar1'
      expect(page).not_to have_content 'bar2'
      expect(page).not_to have_content 'bar3'
    end

    it "nil locale, present search" do
      # impossible for user to replicate this case
      visit phrasing_phrases_path('search' => 'foo', 'commit' => 'Search')
      expect(page).to have_content 'bar1'
      expect(page).not_to have_content 'bar2'
      expect(page).not_to have_content 'bar3'
      visit phrasing_phrases_path('search' => 'fuu', 'commit' => 'Search')
      expect(page).not_to have_content 'foo'
    end

    it "blank locale, foo search" do
      # impossible for user to replicate this case
      visit phrasing_phrases_path('locale' => '', 'commit' => 'Search')
      expect(page).to have_content 'foo'
    end

    it "blank locale, blank search" do
      select '', from: 'locale'
      click_button 'Search'
      expect(page).to have_content 'bar1'
      expect(page).to have_content 'bar2'
      expect(page).to have_content 'bar3'
    end

    it "blank locale, present search" do
      select '', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      expect(page).to have_content 'bar1'
      expect(page).to have_content 'bar2'
      expect(page).to have_content 'bar3'
      fill_in 'search', with: 'fuu'
      click_button 'Search'
      expect(page).not_to have_content 'foo'
    end

    it "present locale, foo search" do
      # impossible for user to replicate this case
      visit phrasing_phrases_path('locale' => 'en', 'commit' => 'Search')
      expect(page).to have_content 'foo'
    end

    it "present locale, blank search" do
      select 'en', from: 'locale'
      click_button 'Search'
      expect(page).to have_content 'bar1'
      expect(page).not_to have_content 'bar2'
      expect(page).not_to have_content 'bar3'
      select 'fa', from: 'locale'
      click_button 'Search'
      expect(page).not_to have_content 'bar1'
      expect(page).to have_content 'bar2'
      expect(page).not_to have_content 'bar3'
      select 'it', from: 'locale'
      click_button 'Search'
      expect(page).not_to have_content 'bar1'
      expect(page).not_to have_content 'bar2'
      expect(page).to have_content 'bar3'
    end

    it "present locale, present search" do
      select 'en', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      expect(page).to have_content 'bar1'
      expect(page).not_to have_content 'bar2'
      expect(page).not_to have_content 'bar3'
      select 'fa', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      expect(page).not_to have_content 'bar1'
      expect(page).to have_content 'bar2'
      expect(page).not_to have_content 'bar3'
      select 'it', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      expect(page).not_to have_content 'bar1'
      expect(page).not_to have_content 'bar2'
      expect(page).to have_content 'bar3'
      select 'en', from: 'locale'
      fill_in 'search', with: 'fuu'
      click_button 'Search'
      expect(page).not_to have_content 'foo'
    end

  end

end

feature "phrasing edit" do
  before do
    FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar")
    visit phrasing_phrases_path
  end

  after do
    PhrasingPhrase.destroy_all
  end

  scenario "visit edit form" do
    fill_in 'search', with: 'foo'
    click_button 'Search'
    click_link 'foo'
    fill_in "phrasing_phrase[value]", with: 'baz'
  end
end

feature "phrasing update" do
  before do
    FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar")
    visit phrasing_phrases_path
    fill_in 'search', with: 'foo'
    click_button 'Search'
    click_link 'foo'
  end

  scenario 'has delete and update buttons' do
    expect(page).to have_selector(:link_or_button, 'Delete Phrase')
    expect(page).to have_selector(:link_or_button, 'Update')
  end

  scenario "update" do
    fill_in "phrasing_phrase[value]", with: 'baz'
    click_button "Update"
    expect(current_path).to eq phrasing_phrases_path
    expect(PhrasingPhrase.find_by_key("foo").value).to eq 'baz'
    expect(page).to have_content "foo updated!"
  end
end

feature 'phrase versions' do
  before do
    phrase = FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar")
    visit edit_phrasing_phrase_path(phrase)
  end

  def update_phrase
    fill_in "phrasing_phrase[value]", with: 'baz'
    click_button "Update"
  end

  it " shows phrases" do
    expect(page).to have_content 'foo'
    expect(page).to have_content 'bar'
  end

  it 'update a phrase and get first phrase versions' do
    expect(PhrasingPhraseVersion.count).to eq 0
    update_phrase
    expect(PhrasingPhraseVersion.count).to eq 1
    expect(current_path).to eq phrasing_phrases_path
    expect(PhrasingPhrase.find_by_key("foo").value).to eq 'baz'
    expect(page).to have_content "foo updated!"
  end

  it 'view first phrase' do
    expect(PhrasingPhraseVersion.count).to eq 0
    update_phrase
    expect(PhrasingPhraseVersion.count).to eq 1
    click_link 'foo'
    expect(page).to have_selector(:link_or_button, 'Delete')
    expect(page).to have_selector(:link_or_button, 'Revert')
    expect(page).to have_content 'bar'
    expect(page).to have_content 'baz'
  end

end

feature "downloading and uploading yaml files" do
  after do
    PhrasingPhrase.destroy_all
  end

  it "round-trips the YAML" do
    FactoryGirl.create(:phrasing_phrase, key: "a.foo1", value: "bar1")
    FactoryGirl.create(:phrasing_phrase, key: "a.foo2:", value: "bar2")
    FactoryGirl.create(:phrasing_phrase, key: "a.b.foo3", value: "bar3")
    FactoryGirl.create(:phrasing_phrase, key: "c.foo4", value: "bar4")
    FactoryGirl.create(:phrasing_phrase, key: 2, value: "bar5")
    expect(PhrasingPhrase.count).to eq 5

    visit import_export_phrasing_phrases_path

    click_link 'Download as YAML'
    PhrasingPhrase.destroy_all
    expect(PhrasingPhrase.count).to eq 0

    yaml = page.source
    file = Tempfile.new 'phrasing'
    file.write yaml
    file.close

    visit import_export_phrasing_phrases_path
    attach_file "file", file.path
    click_button "Upload"
    file.unlink

    expect(PhrasingPhrase.count).to eq 5
    expect(PhrasingPhrase.find_by_key("a.foo1").value).to eq "bar1"
    expect(PhrasingPhrase.find_by_key("a.foo2:").value).to eq "bar2"
    expect(PhrasingPhrase.find_by_key("a.b.foo3").value).to eq "bar3"
    expect(PhrasingPhrase.find_by_key("c.foo4").value).to eq "bar4"
    expect(PhrasingPhrase.find_by_key(2).value).to eq "bar5"
  end

  it "round-trips the yaml with complicated text" do
    value = "“hello world“ üokåa®fgsdf;::fs;kdf"
    FactoryGirl.create(:phrasing_phrase, key: "a.foo", value: value)

    visit import_export_phrasing_phrases_path
    click_link 'Download as YAML'
    PhrasingPhrase.destroy_all

    yaml = page.source
    file = Tempfile.new 'phrasing'
    file.write yaml
    file.close

    visit import_export_phrasing_phrases_path
    attach_file "file", file.path
    click_button "Upload"
    file.unlink
    expect(PhrasingPhrase.find_by_key("a.foo").value).to eq value
  end

  it "gives 400 on bad upload" do
    file = Tempfile.new 'phrasing'
    file.write "<<<%%#$W%s"
    file.close

    visit import_export_phrasing_phrases_path
    attach_file "file", file.path
    click_button "Upload"
    file.unlink
    expect(page.status_code).to eq 400
    expect(page).to have_content("There was an error processing your upload!")
    expect(PhrasingPhrase.count).to eq 0
  end

end

feature "locales" do
  before do
  end
  after do
    PhrasingPhrase.destroy_all
  end
  it "imports yaml containing multiple locales" do
    file = Tempfile.new 'phrasing'
    file.write <<-YAML
      en:
        hello: world
      es:
        hello: mundo
    YAML
    file.close

    visit import_export_phrasing_phrases_path
    attach_file "file", file.path
    click_button "Upload"
    file.unlink

    expect(PhrasingPhrase.count).to eq 2
    a = PhrasingPhrase.where(locale: 'en').first
    expect(a.key).to eq 'hello'
    expect(a.value).to eq 'world'
    b = PhrasingPhrase.where(locale: 'es').first
    expect(b.key).to eq 'hello'
    expect(b.value).to eq 'mundo'
  end

  it "exports yaml containing multiple locales" do
    FactoryGirl.create(:phrasing_phrase, locale: 'en', key: 'hello', value: 'world')
    FactoryGirl.create(:phrasing_phrase, locale: 'es', key: 'hello', value: 'mundo')

    visit download_phrasing_phrases_path
    yaml = page.source
    expect(yaml).to match(/en:\s*hello: world/)
    expect(yaml).to match(/es:\s*hello: mundo/)
  end

end
