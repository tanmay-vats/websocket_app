require 'test_helper'

class ChatChannelTest < ActionCable::Channel::TestCase
  def setup
    subscribe # Establish connection
  end

  # Connection tests
  test 'successful subscription' do
    assert subscription.confirmed?
    assert_has_stream 'chat_channel'
  end

  test 'unsubscribes properly' do
    unsubscribe
    assert_no_streams
  end

  # Message format tests
  test 'broadcasts valid hash messages' do
    message = { content: 'Test', user: 'User1' }
    assert_broadcast_on('chat_channel', message.merge('action' => 'receive')) do
      perform :receive, message
    end
  end

  test 'handles empty message hash' do
    assert_broadcast_on('chat_channel', {}.merge('action' => 'receive')) do
      perform :receive, {}
    end
  end

  test 'rejects non-hash messages' do
    # Test with plain string
    assert_raises(NoMethodError) do
      perform :receive, 'plain string'
    end

    # Test with array
    ex = assert_raises(NoMethodError) do
      perform :receive, [ 1, 2, 3 ]
    end
    assert_match(/undefined method `stringify_keys' for/, ex.message)
  end

  test 'rejects nil messages' do
    assert_raises(NoMethodError) do
      perform :receive, nil
    end
  end

  # Content tests
  test 'handles special characters' do
    special_chars = "!@\#$%^&*()_+-=[]{}|;':\",./<>?"
    message = { content: special_chars }

    # For Minitest, use this exact assertion format:
    assert_broadcast_on('chat_channel', {
      'content' => special_chars,
      'action' => 'receive'
    }) do
      perform :receive, message
    end
  end

  # Content handling tests
  test 'handles HTML content' do
    message = { content: '<div>Test</div>' }
    assert_broadcast_on('chat_channel', message.merge(action: 'receive')) do
      perform :receive, message
    end
  end

  test 'handles JSON content' do
    message = { json: { key: 'value' }.to_json }
    assert_broadcast_on('chat_channel', message.merge(action: 'receive')) do
      perform :receive, message
    end
  end

  test 'handles large messages (10KB)' do
    large_content = 'a' * 10_000
    message = { content: large_content }
    assert_broadcast_on('chat_channel', message.merge(action: 'receive')) do
      perform :receive, message
    end
  end

  # Stress tests
  test 'handles rapid sequential messages' do
    5.times do |i|
      message = { count: i }
      assert_broadcast_on('chat_channel', message.merge(action: 'receive')) do
        perform :receive, message
      end
    end
  end
end
