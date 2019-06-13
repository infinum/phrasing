require 'spec_helper'

describe PhrasingPhrasesController do
  describe 'GET #new' do
    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end

    let(:phrase) { FactoryBot.create(:phrasing_phrase, value: 'old_value') }

    it 'updates phrase' do
      expect do
        xhr(:put, :update, klass: 'PhrasingPhrase',
                           attribute: 'value',
                           id: phrase.id,
                           new_value: 'new_value')
      end.to change { phrase.reload.value }.from('old_value').to('new_value')

      expect(response.code).to eq('200')
    end

    it 'updates phrase' do
      expect do
        xhr(:put, :update, klass: 'PhrasingPhrase',
                           attribute: 'locale',
                           id: phrase.id,
                           new_value: 'de')
      end.to_not change { phrase.reload.locale }

      expect(response.code).to eq('403')
    end
  end
end
