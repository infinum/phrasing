#encoding: utf-8
require 'spec_helper'

feature 'edit mode bubble' do

  before do
    visit root_path
  end

  it '(un)check edit mode checkbox' do
    edit_mode_checkbox = find(:css, ".onoffswitch-checkbox")
    edit_mode_checkbox.should be_checked
    edit_mode_checkbox.set(false)
    edit_mode_checkbox.should_not be_checked
  end

  it "phrases should have class 'phrasable_on' and contenteditable=true" do
    page.find('.header').first('.phrasable').text.should == 'The Header'
    page.find('.header').first('.phrasable')['class'].should == 'phrasable phrasable_on'
    page.find('.header').first('.phrasable')['contenteditable'].should == 'true'
  end

  it 'should be able to visit phrasing index via edit_all icon' do
    find(:css, ".phrasing-edit-all-phrases-link").click
    current_path.should == phrasing_phrases_path
  end

  xit "phrases should have class shouldn't have class phrasable on when edit mode is off", js: true do
    edit_mode_checkbox = find(:css, ".onoffswitch-checkbox")
    edit_mode_checkbox.click
    page.find('.header').first('.phrasable')['class'].should == 'phrasable'
  end

  xit 'edit phrases', js: true do
    header_phrase = page.find('.header').first('.phrasable')
    header_phrase['class'].should == 'phrasable phrasable_on'
    header_phrase.text.should == 'The Header'
    header_phrase.set "content"
    header_phrase.text.should == 'content'
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
    page.should have_content 'foo'
    page.should have_content 'bar'
  end

  it "allows search by key" do
    fill_in 'search', with: 'foo'
    click_button 'Search'
    page.should have_content 'foo'
    page.should have_content 'bar'
  end

  it "allows search by key" do
    fill_in 'search', with: 'xfoo'
    click_button 'Search'
    page.should_not have_content 'foo'
    page.should_not have_content 'bar'
  end

  it "allows search by value" do
    fill_in 'search', with: 'bar'
    click_button 'Search'
    page.should have_content 'foo'
    page.should have_content 'bar'
  end

  it "allows search by value" do
    fill_in 'search', with: 'xbar'
    click_button 'Search'
    page.should_not have_content 'foo'
    page.should_not have_content 'bar'
  end

  it "searches in the middles of strings" do
    FactoryGirl.create(:phrasing_phrase, key: "site.index.something")
    fill_in 'search', with: 'index'
    click_button 'Search'
    page.should have_content 'site.index.something'
  end

  it "can show all" do
    FactoryGirl.create(:phrasing_phrase, key: "foe", value: "beer")
    click_button 'Search'
    page.should have_content 'foo'
    page.should have_content 'foe'
  end

  it 'not null values first, global order by key' do
    FactoryGirl.create(:phrasing_phrase, key: "foo1", value: nil)
    FactoryGirl.create(:phrasing_phrase, key: "foo2", value: "beer")
    FactoryGirl.create(:phrasing_phrase, key: "foo3", value: nil)
    visit phrasing_phrases_path
    page.body.should =~ /foo[\s\S]*foo2[\s\S]*foo1[\s\S]*foo3/
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
      page.should have_content 'bar1'
      page.should_not have_content 'bar2'
      page.should_not have_content 'bar3'
    end

    it "nil locale, present search" do
      # impossible for user to replicate this case
      visit phrasing_phrases_path('search' => 'foo', 'commit' => 'Search')
      page.should have_content 'bar1'
      page.should_not have_content 'bar2'
      page.should_not have_content 'bar3'
      visit phrasing_phrases_path('search' => 'fuu', 'commit' => 'Search')
      page.should_not have_content 'foo'
    end

    it "blank locale, foo search" do
      # impossible for user to replicate this case
      visit phrasing_phrases_path('locale' => '', 'commit' => 'Search')
      page.should have_content 'foo'
    end

    it "blank locale, blank search" do
      select '', from: 'locale'
      click_button 'Search'
      page.should have_content 'bar1'
      page.should have_content 'bar2'
      page.should have_content 'bar3'
    end

    it "blank locale, present search" do
      select '', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      page.should have_content 'bar1'
      page.should have_content 'bar2'
      page.should have_content 'bar3'
      fill_in 'search', with: 'fuu'
      click_button 'Search'
      page.should_not have_content 'foo'
    end

    it "present locale, foo search" do
      # impossible for user to replicate this case
      visit phrasing_phrases_path('locale' => 'en', 'commit' => 'Search')
      page.should have_content 'foo'
    end

    it "present locale, blank search" do
      select 'en', from: 'locale'
      click_button 'Search'
      page.should have_content 'bar1'
      page.should_not have_content 'bar2'
      page.should_not have_content 'bar3'
      select 'fa', from: 'locale'
      click_button 'Search'
      page.should_not have_content 'bar1'
      page.should have_content 'bar2'
      page.should_not have_content 'bar3'
      select 'it', from: 'locale'
      click_button 'Search'
      page.should_not have_content 'bar1'
      page.should_not have_content 'bar2'
      page.should have_content 'bar3'
    end

    it "present locale, present search" do
      select 'en', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      page.should have_content 'bar1'
      page.should_not have_content 'bar2'
      page.should_not have_content 'bar3'
      select 'fa', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      page.should_not have_content 'bar1'
      page.should have_content 'bar2'
      page.should_not have_content 'bar3'
      select 'it', from: 'locale'
      fill_in 'search', with: 'foo'
      click_button 'Search'
      page.should_not have_content 'bar1'
      page.should_not have_content 'bar2'
      page.should have_content 'bar3'
      select 'en', from: 'locale'
      fill_in 'search', with: 'fuu'
      click_button 'Search'
      page.should_not have_content 'foo'
    end

  end

end

feature "phrasing edit" do
  before do
    FactoryGirl.create(:phrasing_phrase, key: "foo", value: "bar")
    visit phrasing_phrases_path
  end
  after do
    PhrasingPhrase.delete_all
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

  scenario "update" do
    fill_in "phrasing_phrase[value]", with: 'baz'
    click_button "Update"
    current_path.should == phrasing_phrases_path
    PhrasingPhrase.find_by_key("foo").value.should == 'baz'
    page.should have_content "foo updated!"
  end
end

feature "downloading and uploading yaml files" do
  after do
    PhrasingPhrase.delete_all
  end

  it "round-trips the YAML" do
    FactoryGirl.create(:phrasing_phrase, key: "a.foo1", value: "bar1")
    FactoryGirl.create(:phrasing_phrase, key: "a.foo2:", value: "bar2")
    FactoryGirl.create(:phrasing_phrase, key: "a.b.foo3", value: "bar3")
    FactoryGirl.create(:phrasing_phrase, key: "c.foo4", value: "bar4")
    FactoryGirl.create(:phrasing_phrase, key: 2, value: "bar5")
    assert PhrasingPhrase.count == 5

    visit import_export_phrasing_phrases_path

    click_link 'Download as YAML'
    PhrasingPhrase.destroy_all
    assert PhrasingPhrase.count == 0

    yaml = page.source
    file = Tempfile.new 'phrasing'
    file.write yaml
    file.close

    visit import_export_phrasing_phrases_path
    attach_file "file", file.path
    click_button "Upload"
    file.unlink

    assert PhrasingPhrase.count == 5
    assert PhrasingPhrase.find_by_key("a.foo1").value == "bar1"
    assert PhrasingPhrase.find_by_key("a.foo2:").value == "bar2"
    assert PhrasingPhrase.find_by_key("a.b.foo3").value == "bar3"
    assert PhrasingPhrase.find_by_key("c.foo4").value == "bar4"
    assert PhrasingPhrase.find_by_key(2).value == "bar5"
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
    assert PhrasingPhrase.find_by_key("a.foo").value == value
  end

  it "gives 400 on bad upload" do
    file = Tempfile.new 'phrasing'
    file.write "<<<%%#$W%s"
    file.close

    visit import_export_phrasing_phrases_path
    attach_file "file", file.path
    click_button "Upload"
    file.unlink
    page.status_code.should == 400
    page.should have_content("There was an error processing your upload!")
    assert PhrasingPhrase.count == 0
  end

end

feature "locales" do
  before do
  end
  after do
    PhrasingPhrase.delete_all
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

    assert PhrasingPhrase.count == 2
    a = PhrasingPhrase.where(locale: 'en').first
    assert a.key == 'hello'
    assert a.value == 'world'
    b = PhrasingPhrase.where(locale: 'es').first
    assert b.key == 'hello'
    assert b.value == 'mundo'
  end

  it "exports yaml containing multiple locales" do
    FactoryGirl.create(:phrasing_phrase, locale: 'en', key: 'hello', value: 'world')
    FactoryGirl.create(:phrasing_phrase, locale: 'es', key: 'hello', value: 'mundo')

    visit download_phrasing_phrases_path
    yaml = page.source
    assert yaml =~ /en:\s*hello: world/
    assert yaml =~ /es:\s*hello: mundo/
  end

end