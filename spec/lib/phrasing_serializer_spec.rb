#encoding: utf-8
require 'spec_helper'

describe Phrasing::Serializer do

  let(:english_phrases) do
    PhrasingPhrase.where(locale: :en)
  end

  let(:french_phrases) do
    PhrasingPhrase.where(locale: :fr)
  end

  describe 'flatten_the_hash' do

    it 'with simple data' do
      hash = { "site.intro" => "Hello", "site.outro" => "KthnxBye", "site.overture" => "The Butler"}
      new_hash = Phrasing::Serializer.flatten_the_hash(hash)
      expect(new_hash).to eq(hash)
    end

    it 'with nested data' do
      hash = { "site.text" => {"intro" => "Hello", "outro" => "KthnxBye"}}
      new_hash = Phrasing::Serializer.flatten_the_hash(hash)

      predicted_new_hash = { "site.text.intro" => "Hello", "site.text.outro" => "KthnxBye" }
      expect(new_hash).to eq(predicted_new_hash)
    end

    it 'with deeply nested data' do
      hash = { "site" => {"text" => {"intro" => "Hello", "outro" => "KthnxBye", "overture" => {"intro" => "Overture intro", "outro" => "Overture outro"}}}}
      new_hash = Phrasing::Serializer.flatten_the_hash(hash)

      predicted_new_hash = { "site.text.intro" => "Hello", "site.text.outro" => "KthnxBye", "site.text.overture.intro" => "Overture intro", "site.text.overture.outro" => "Overture outro"}
      expect(new_hash).to eq(predicted_new_hash)
    end

  end

  context 'import_yaml' do

    it 'simply formatted phrases' do
      yaml = <<-YAML
        en:
          intro: "Hello World"
          outro: "Kthnx Bye"
      YAML
      Phrasing::Serializer.import_yaml(StringIO.new(yaml))

      expect(english_phrases.where(key: "intro").first.value).to eq("Hello World")
      expect(english_phrases.where(key: "outro").first.value).to eq("Kthnx Bye")
    end

    it 'nested phrases' do
      yaml = <<-YAML
        en:
          site:
            intro: "Hello World"
            outro: "Kthnx Bye"
      YAML
      Phrasing::Serializer.import_yaml(StringIO.new(yaml))

      expect(english_phrases.where(key: "site.intro").first.value).to eq("Hello World")
      expect(english_phrases.where(key: "site.outro").first.value).to eq("Kthnx Bye")
    end

    it 'deeply nested phrases' do
      yaml = <<-YAML
        en:
          site:
            text:
              intro: "Hello World"
              outro: "Kthnx Bye"
              overture:
                intro: "Overture intro"
                outro: "Overture outro"
      YAML
      Phrasing::Serializer.import_yaml(StringIO.new(yaml))

      expect(english_phrases.where(key: "site.text.intro").first.value).to eq("Hello World")
      expect(english_phrases.where(key: "site.text.outro").first.value).to eq("Kthnx Bye")

      expect(english_phrases.where(key: "site.text.overture.intro").first.value).to eq("Overture intro")
      expect(english_phrases.where(key: "site.text.overture.outro").first.value).to eq("Overture outro")
    end


    it 'overrides old values' do
      FactoryGirl.create(:phrasing_phrase, key: "site.intro", value: "Go Home")
      FactoryGirl.create(:phrasing_phrase, key: "site.outro", value: "Kthnx Bye")

      expect(english_phrases.where(key: "site.intro").first.value).to eq("Go Home")
      expect(english_phrases.where(key: "site.outro").first.value).to eq("Kthnx Bye")

      yaml = <<-YAML
        en:
          site:
            intro: "Hello World"
      YAML
      number_of_changes = Phrasing::Serializer.import_yaml(StringIO.new(yaml))

      expect(english_phrases.where(key: "site.intro").first.value).to eq("Hello World")
      expect(english_phrases.where(key: "site.outro").first.value).to eq("Kthnx Bye")

      expect(number_of_changes).to eq(1)
    end

  end


  context 'imports and exports' do
    it 'without changing, should return 0 number of changes' do
      FactoryGirl.create(:phrasing_phrase, key: "site.intro", value: "Go Home")
      FactoryGirl.create(:phrasing_phrase, key: "site.outro", value: "Kthnx Bye")

      expect(english_phrases.where(key: "site.intro").first.value).to eq("Go Home")
      expect(english_phrases.where(key: "site.outro").first.value).to eq("Kthnx Bye")

      yaml = Phrasing::Serializer.export_yaml

      number_of_changes = Phrasing::Serializer.import_yaml(StringIO.new(yaml))

      expect(english_phrases.where(key: "site.intro").first.value).to eq("Go Home")
      expect(english_phrases.where(key: "site.outro").first.value).to eq("Kthnx Bye")
      expect(number_of_changes).to eq(0)
    end
  end


  context 'export_yaml' do
    it 'flattened phrases' do
      FactoryGirl.create(:phrasing_phrase, key: "site.intro", value: "Go Home")
      FactoryGirl.create(:phrasing_phrase, key: "site.outro", value: "Kthnx Bye")

      expect(english_phrases.where(key: "site.intro").first.value).to eq("Go Home")
      expect(english_phrases.where(key: "site.outro").first.value).to eq("Kthnx Bye")

      yaml = Phrasing::Serializer.export_yaml

      expect(yaml).to match(/site.intro:\sGo Home/)
      expect(yaml).to match(/site.outro:\sKthnx Bye/)
    end

    it 'with different locales' do
      FactoryGirl.create(:phrasing_phrase, key: "site.intro", value: "Hello", locale: :en)
      FactoryGirl.create(:phrasing_phrase, key: "site.intro", value: "Bonjour", locale: :fr)

      expect(english_phrases.where(key: "site.intro").first.value).to eq("Hello")
      expect(french_phrases.where(key: "site.intro").first.value).to eq("Bonjour")

      yaml = Phrasing::Serializer.export_yaml

      expect(yaml).to match(/en:\s*\n\s*site.intro:\sHello/)
      expect(yaml).to match(/fr:\s*\n\s*site.intro:\sBonjour/)
    end

  end



end




