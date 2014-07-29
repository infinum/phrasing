#encoding: utf-8
require 'spec_helper'

describe PhrasingPhrase do

  describe "database constraints" do
    context "validates uniqueness of key & locale" do

      it 'on #save! should raise errors if the key and locale are the same for two phrases' do
        PhrasingPhrase.create(key: "foo", locale: "en", value: "bar")
        new_phrase = PhrasingPhrase.new(key: "foo", locale: "en", value: "bar2")
        expect { new_phrase.save! }.to raise_error
      end

      it 'on #save, if the key and locale are the same for two phrases, the latter one should be invalid' do
        PhrasingPhrase.create(key: "foo", locale: "en", value: "bar")
        new_phrase = PhrasingPhrase.create(key: "foo", locale: "en", value: "bar2")
        expect(new_phrase).to be_invalid
      end

      it "shouldn't raise errors if the key is the same but locales are different" do
       PhrasingPhrase.create(key: "foo", locale: "en", value: "bar")
       new_phrase = PhrasingPhrase.new(key: "foo", locale: "fr", value: "bar")
       expect { new_phrase.save! }.not_to raise_error
       expect(new_phrase).to be_valid
     end

    end
  end

end




