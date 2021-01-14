import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "cartcount", "carttotalprice"]
 
  update(e) {
    e.preventDefault()
    console.log(e.detail)
    console.log(this.carttotalpriceTarget)
    const {count, total_price, shoptotal} = e.detail
    this.cartcountTarget.innerText = `${count}`
    this.carttotalpriceTarget.innerText = `${total_price}`
  }
}
