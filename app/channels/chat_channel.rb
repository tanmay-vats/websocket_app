class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end

  def receive(data)
    # Convert to hash safely before Action Cable processes it
    message = convert_to_hash(data)
    ActionCable.server.broadcast('chat_channel', message.merge(action: 'receive'))
  end

  private

  def convert_to_hash(data)
    case data
    when Hash then data
    when nil then raise ArgumentError, 'Message cannot be nil'
    else
      if data.respond_to?(:to_h)
        data.to_h
      else
        raise ArgumentError, 'Message must be a hash'
      end
    end
  rescue => e
    raise ArgumentError, 'Invalid message format'
  end
end
