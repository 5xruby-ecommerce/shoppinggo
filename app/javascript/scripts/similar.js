document.addEventListener('turbolinks:load',()=>{
  document.querySelectorAll('.cardstyle').forEach( e =>{
   e.addEventListener('mouseover',()=>{
     e.classList.add('cardhover')
   })
   e.addEventListener('mouseout',()=>{
     e.classList.remove('cardhover')
   })
  })

})
