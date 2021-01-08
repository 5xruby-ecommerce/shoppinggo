import consumer from "./consumer"

document.addEventListener('turbolinks:load',()=>{

  const room = document.querySelector('.message_box')
  if(!room)return
  const room_id = room.dataset.room
  if (consumer.subscriptions.subscriptions.length === 0){
    consumer.subscriptions.create({channel:"ChatroomChannel", room_id: room_id}, {
      connected() {
        console.log('connecting'+ room_id)
        // Called when the subscription is ready for use on the server
      },
  
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
  
      received(data) {
        console.log('received!!')
        const user_id = Number(document.querySelector('.message_box').dataset.user)
        const message_area = document.querySelector('.message_area')
        const form = document.forms[1]
        console.log(form)
        
        if(data.message.user_id === user_id){
          message_area.innerHTML += data.my_message
        }else{
          message_area.innerHTML += data.other_message
        }
  
        form.reset()
  
        message_area.scrollTop = message_area.scrollHeight
  
      }
    });
  }

})

