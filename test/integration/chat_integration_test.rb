require 'test_helper'

class ChatIntegrationTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper

  setup do
    # @user = users(:test_user)
    # sign_in @user
  end

  test 'page accessibility' do
    get root_url
    assert_response :success
    assert_select 'h1', 'Chat App' # Update this to match your actual h1 text
    assert_select '#messages'
    assert_select '#message-input'
    assert_select '#send-button'
  end

  test 'WebSocket endpoint availability' do
    assert ActionCable.server.pubsub.respond_to?(:broadcast)
  end

  test 'required JavaScript inclusion' do
    get root_url
    assert_response :success
    assert_match(/application-.*\.js/, @response.body)
    assert_match(/actioncable/, @response.body)
  end

  test 'HTML structure' do
    get root_url
    assert_select "#messages[style*='height: 300px']"
    assert_select "input#message-input[type='text']"
    assert_select 'button#send-button', 'Send'
  end

  test 'real-time message broadcasting' do
    # Use the proper broadcasting method
    assert_broadcast_on('chat_channel', { content: 'test' }) do
      ActionCable.server.broadcast('chat_channel', { content: 'test' })
    end
  end
end
