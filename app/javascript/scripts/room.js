document.addEventListener('turbolinks:load',()=>{
  const getchat = document.querySelector('#getchat')
  if (getchat) {
    getchat.addEventListener('click',clickHandler)
  }
})

document.addEventListener('turbolinks:load',()=>{
  const btn = document.querySelector('.cbtn')
  if (btn) {
    btn.addEventListener('click',clickHandler)
  }
})

function clickHandler(){
    document.querySelector('.zone').classList.toggle('hidden')
    document.querySelector('.chatroom').classList.toggle('show')
    document.querySelector('.fa-caret-square-down').classList.toggle('none')
    document.querySelector('.cbtn').classList.toggle('absolute')
    document.querySelector('.cbtn').classList.toggle('mini')
  }