import { Controller } from "stimulus"
import Rails from '@rails/ujs'
//import ax from 'axios'

export default class extends Controller {
  static targets = [ "icon" ]
  
  go(e) {
    const item = e.currentTarget.parentNode.parentNode.parentNode
    e.preventDefault();
    const id = this.data.get('id')
    Rails.ajax({
      url: `/products/${id}/favorite`,
      type: 'post',
      success: (resp) => {
        if (resp.status == "added") {
          this.iconTarget.classList.remove("far")
          this.iconTarget.classList.add("fas")
          document.querySelector('#fav').textContent = '已喜歡'
        } else {
          this.iconTarget.classList.remove("fas")
          this.iconTarget.classList.add("far")
          document.querySelector('#fav').textContent = '喜歡'
          item.remove()
        }
      },
      error: function(err) {
        console.log(err);
      }
    })
  }


  remove_fav(e) {
    const item = e.currentTarget.parentNode.parentNode.parentNode
    e.preventDefault();
    const id = this.data.get('id')
    Rails.ajax({
      url: `/products/${id}/favorite`,
      type: 'post',
      success: (resp) => {
        this.iconTarget.classList.remove("fas")
        this.iconTarget.classList.add("far")
        item.remove()    
      },
      error: function(err) {
        console.log(err);
      }
    })
  }

}
