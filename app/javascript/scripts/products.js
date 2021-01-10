document.addEventListener("DOMContentLoaded", function(){
  const favorite_btn = document.querySelector('#favorite_btn')

  favorite_btn.addEventListener("click", function(e) {
    e.preventDefault()
    console.log(e.currentTarget.dataset.id);
    //alert('收藏至我的最愛')
  })
})