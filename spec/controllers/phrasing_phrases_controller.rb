require 'spec_helper'

describe PhrasingPhrasesController do
  describe 'GET #new' do
    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'PUT #update' do
    let(:phrase) { FactoryBot.create(:phrasing_phrase, value: 'old_value') }

    context 'when edit model is enabled' do
      it 'updates phrase' do
        expect do
          xhr(
            :put,
            :update,
            klass: 'PhrasingPhrase',
            attribute: 'value',
            id: phrase.id,
            new_value: 'new_value',
            edit_model_enabled: 'true'
          )
        end.to change { phrase.reload.value }.from('old_value').to('new_value')

        expect(response.code).to eq('200')
      end

      it "doesn't update locale" do
        expect do
          xhr(
            :put,
            :update,
            klass: 'PhrasingPhrase',
            attribute: 'locale',
            id: phrase.id,
            new_value: 'de',
            edit_model_enabled: 'true'
          )
        end.to_not(change { phrase.reload.locale })

        expect(response.code).to eq('403')
      end
    end

    context 'when edit mode is disabled' do
      it "doesn't update phrase" do
        expect do
          xhr(
            :put,
            :update,
            klass: 'PhrasingPhrase',
            attribute: 'value',
            id: phrase.id,
            new_value: 'new_value',
            edit_model_enabled: 'false'
          )
        end.not_to(change { phrase.reload.value })

        expect(response.code).to eq('403')
      end
    end
  end
end
