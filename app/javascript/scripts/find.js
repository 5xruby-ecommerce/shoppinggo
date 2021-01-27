document.addEventListener("turbolinks:load", function(){
  const card = document.querySelector('.onecard')
  if (card) {
    card.addEventListener('mouseenter',function(){
      document.querySelector('.searchsame').classList.toggle('opacity-0')
      document.querySelector('.searchsame').classList.toggle('findsame')
    })
    card.addEventListener('mouseleave',function(){
      document.querySelector('.searchsame').classList.toggle('opacity-0')
      document.querySelector('.searchsame').classList.toggle('findsame')
    })
 
  }
})