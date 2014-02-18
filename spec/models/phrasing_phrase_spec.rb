#encoding: utf-8
require 'spec_helper'

describe PhrasingPhrase do

  describe "database constraints" do
    it "validates uniqueness of key & locale" do
      PhrasingPhrase.new(key: "foo", locale: "en", value: "bar").save
      # a = PhrasingPhrase.new(key: "foo", locale: "en", value: "bar2")
      # expect { a.save }.to raise_error
      b = PhrasingPhrase.new(key: "foo", locale: "fa", value: "bar")
      expect { b.save }.not_to raise_error
    end
  end

  it "imports YAML" do
    FactoryGirl.create(:phrasing_phrase, :key => "sample_copy", :value => "copyfoo")
    FactoryGirl.create(:phrasing_phrase, :key => "sample_copy2", :value => "copybaz")

    assert PhrasingPhrase.find_by_key("sample_copy").value == "copyfoo"
    assert PhrasingPhrase.find_by_key("sample_copy2").value == "copybaz"
    assert PhrasingPhrase.find_by_key("hello").nil?

    yaml = <<-YAML
      en:
        hello: "Hello world"
        sample_copy: "lorem ipsum"
    YAML
    PhrasingPhrase.import_yaml(StringIO.new(yaml))

    assert PhrasingPhrase.find_by_key("sample_copy").value == "lorem ipsum"
    assert PhrasingPhrase.find_by_key("sample_copy2").value == "copybaz"
    assert PhrasingPhrase.find_by_key("hello").value == "Hello world"
  end

  it "imports YAML with nested keys" do
    yaml = <<-YAML
      en:
        site:
          header:
            title: "Hello world"
    YAML
    PhrasingPhrase.import_yaml(StringIO.new(yaml))
    assert PhrasingPhrase.find_by_key("site.header.title").value == "Hello world"
  end

  it "exports and then imports complicated YAML" do
    key = "moby_dick"
    value = %|<p>Lorem ipsum</p><p class="highlight">∆'≈:</p>|
    FactoryGirl.create(:phrasing_phrase, key: key, value: value)
    yaml = PhrasingPhrase.export_yaml
    PhrasingPhrase.destroy_all
    PhrasingPhrase.import_yaml(StringIO.new(yaml))
    PhrasingPhrase.find_by_key(key).value.should == value
  end

end




