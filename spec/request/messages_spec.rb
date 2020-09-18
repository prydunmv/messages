require 'rails_helper'

RSpec.describe 'Message', type: :request do

  describe 'POST /messages' do
    let(:message_params) do
      {
        message: {
          message: 'hi! sorry i`m busy',
          viewed: false
        }
      }
    end

    it 'creates message record', tdd: true do
      expect do
        post '/messages', params: message_params
      end.to change { Message.count }.by(1)
    end

    it 'returns "created" status' do
      post '/messages', params: message_params

      expect(response.status).to eq(201)
    end
  end

  describe 'GET /messages/:message_id' do

    let(:message){FactoryBot.create(:message)}

    it 'returns json first view message' do
      get "/messages/#{message.id}"

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['viewed'])
        .to eq(true)
    end

    context 'when viewed is true' do
      let(:message){FactoryBot.create(:message, viewed: true)}
      it 'returns json second view message' do
        get "/messages/#{message.id}"

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['error'])
          .to eq('You already requested this message')
      end
    end
  end

  # describe 'GET /messages/:message_id' do

  #   let(:message){FactoryBot.create(message: message, viewed: true)}


  # end





end
