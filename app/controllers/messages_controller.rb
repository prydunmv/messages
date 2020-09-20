class MessagesController < ApplicationController
  before_action :message, only: %i[show]

  def index
    @messages = Message.where(viewed: false)

    render json: ActiveModelSerializers::SerializableResource.new(@messages.to_a).to_json
  end

  def show
    if @message.viewed
      @message.destroy
      render json: { error: 'You already requested this message' }
      return
    end

    @message.update(viewed: true)
    render json: ActiveModelSerializers::SerializableResource.new(@message)
  end

  def create
    @message = Message.create(message_params)

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
    params.fetch(:message, {}).permit(:message, :viewed)
  end

end
