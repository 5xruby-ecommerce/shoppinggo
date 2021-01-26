document.addEventListener('turbolinks:load', function(){
  document.querySelector('.X').addEventListener('click',()=>{
    console.log('hell')
    document.querySelector('.modal').remove()
  })
  var timer = setInterval(down,1000)
  function down (){
    document.querySelector('.text').innerText=`倒數+time`
  }
})