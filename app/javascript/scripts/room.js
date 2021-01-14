document.addEventListener('turbolinks:load',()=>{
  const btn = document.querySelector('.btn')
  function clickHandler(){
    document.querySelector('.zone').classList.toggle('hidden')
    document.querySelector('.chatroom').classList.toggle('show')
    document.querySelector('.fa-caret-square-down').classList.toggle('none')
    btn.classList.toggle('absolute')
    btn.classList.toggle('mini')
  }

  btn.addEventListener('click',clickHandler)
})