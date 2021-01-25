document.addEventListener('turbolinks:load', function(){
  document.querySelector('.X').addEventListener('click',()=>{
    console.log('hell')
    document.querySelector('.modal').remove()
  })
})