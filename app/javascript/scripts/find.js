document.addEventListener("turbolinks:load", function(){
  const card = document.querySelectorAll('.onecard')
  if (card) {
    card.forEach((one)=>{
      one.addEventListener('mouseenter',function(){
      one.querySelector('.searchsame').classList.toggle('opacity-0')
      one.querySelector('.searchsame').classList.toggle('findsame')
      })
    })
    
    card.forEach((one)=>{
      one.addEventListener('mouseleave',function(){
      one.querySelector('.searchsame').classList.toggle('opacity-0')
      one.querySelector('.searchsame').classList.toggle('findsame')
      })
    })
    
  }
})