document.addEventListener('turbolinks:load', function(){
  if (document.querySelector('.X')) {
    document.querySelector('.X').addEventListener('click',()=>{
      document.querySelector('.modal').remove()
    })  
  }
})