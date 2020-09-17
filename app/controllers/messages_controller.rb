class MessagesController < ApplicationController
  before_action :message, only: %i[show]

  def index
    @messages = Messages.all

    render json: MessagesSerializer.new(messages).serialized_json, status: :ok
  end

  def show
    if @message.viewed

      @message.destroy
      render json: 'You already requested this message'.to_json, status: :no_content
    end

    @message.update(viewed: true)
    render json: MessagesSerializer.new(@message).serialized_json, status: :ok
  end

  def create
    @message = Message.creare(message_params)

    if @message.save
      render json: 'message was successfully created'.to_json, status: :created
    else
      render json: @message.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end

  private

  def message
    @message ||= Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body)
  end

end
