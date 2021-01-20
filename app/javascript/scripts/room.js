document.addEventListener('turbolinks:load',()=>{
  const getchat = document.querySelector('#getchat')
  if (getchat) {
    getchat.addEventListener('click',clickHandler)
  }
})

document.addEventListener('turbolinks:load',()=>{
  const btn = document.querySelector('.btn')
  if (btn) {
    btn.addEventListener('click',clickHandler)
  }
})

function clickHandler(){
    document.querySelector('.zone').classList.toggle('hidden')
    document.querySelector('.chatroom').classList.toggle('show')
    document.querySelector('.fa-caret-square-down').classList.toggle('none')
    document.querySelector('.btn').classList.toggle('absolute')
    document.querySelector('.btn').classList.toggle('mini')
  }