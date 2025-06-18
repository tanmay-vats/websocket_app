import { createConsumer } from "@rails/actioncable"

const cable = createConsumer()
const channel = cable.subscriptions.create("ChatChannel", {
  received(data) {
    console.log("Received:", data)
    document.querySelector('#messages').insertAdjacentHTML('beforeend', `<div>${data.message}</div>`)
  }
})

document.querySelector('#send-button').addEventListener('click', () => {
  const message = document.querySelector('#message-input').value
  channel.send({ message: message })
  document.querySelector('#message-input').value = ''
})
