document.addEventListener("DOMContentLoaded", function(){
  const favorite_btn = document.querySelector('#favorite_btn')

  if (favorite_btn) {
    favorite_btn.addEventListener("click", function(e) {
      e.preventDefault()
      const ax = require('@rails/ujs')
      const token = document.querySelector('[name=csrf-token]').content
        ax.defaults.headers.common['X-CSRF-TOKEN'] = token
    
      const productId = e.currentTarget.dataset.id
      const icon = e.target

      ax.post(`/products/${productId}/favorite`, {})
        .then(function(resp){
          if (resp.data.status == "added") {
            icon.classList.remove("far")
            icon.classList.add("fas")
          } else {
            icon.classList.remove("fas")
            icon.classList.add("far")
          }
        })
          
        .catch(function(err) {
          console.log(err);
        })
    })
  }
})