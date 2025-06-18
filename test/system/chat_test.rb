require 'application_system_test_case'

class ChatTest < ApplicationSystemTestCase
  include ActionCable::TestHelper

  setup do
    visit root_url
  end

  test 'message flow' do
    fill_in 'message-input', with: 'Hello world'
    click_button 'Send'
    assert_selector '#messages div', text: 'Hello world'
  end

  test 'special characters' do
    fill_in 'message-input', with: "!@\#$%^&*()"
    click_button 'Send'
    assert_selector '#messages div', text: "!@\#$%^&*()"
  end

  test 'multiple clients' do
    using_session(:second_user) do
      visit root_url
    end

    fill_in 'message-input', with: 'Multi-test'
    click_button 'Send'

    using_session(:second_user) do
      assert_selector '#messages div', text: 'Multi-test'
    end
  end
end
