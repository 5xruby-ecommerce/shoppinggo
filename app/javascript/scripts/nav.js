window.addEventListener('DOMContentLoaded',()=>{
  document.querySelector('.nav-toggler').addEventListener('click',()=>{
    const nav = document.querySelector('.navigation')
    if (nav.style.display === 'none'){
      nav.style.display = 'block'
    }else{
      nav.style.display = 'none'
    }
  })
})
    