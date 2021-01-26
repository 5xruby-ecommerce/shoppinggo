document.addEventListener('turbolinks:load', function(){
  if (document.querySelector('.X')) {
    document.querySelector('.X').addEventListener('click',()=>{
      console.log('hell')
      document.querySelector('.modal').remove()
    })  
  }
})