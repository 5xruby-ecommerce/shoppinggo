import { Controller } from "stimulus"
import magicRails from '@rails/ujs'

function updateCartTotal() {
  let carttotal = document.querySelector('.cart_total')
  let items = document.querySelectorAll('.item_total_price')

  let totalprice = 0
  for (let i = 0; i< items.length; i++) {
    totalprice += Number(items[i].textContent)
  }
  carttotal.textContent = totalprice
}

export default class extends Controller {
  static targets = [ "amount", "additem", "totalprice" , 'price']
  static values = { number: Number, totalprice: Number }
 

  connect() {
    this.numberValueChanged()
  }

  plusbtn(e) {
    this.numberValue++
    const id = this.data.get('id');
    const additemController = document.querySelector('.content')
    const amount = { amount: 1 }
    magicRails.ajax({
      url:  `/carts/update_item/${id}`,
      type: 'post',
      contentType: 'application/json', // 指定傳送到 server 的資料類型
      data: JSON.stringify(amount),
      success: (resp) => {
        console.log(resp, this.amountTarget.value);
      },
      error: (err) => {
        console.log(err);
      }
    })
  }

  minusbtn(e) {
    if (this.amountTarget.value >= 2) {
      this.numberValue--;
      const id = this.data.get('id');
      const additemController = document.querySelector('.content')
      const amount = { amount: -1 }
      magicRails.ajax({
        url:  `/carts/update_item/${id}`,
        type: 'post',
        contentType: 'application/json', // 指定傳送到 server 的資料類型
        data: JSON.stringify(amount),
        success: (resp) => {
          console.log(resp, this.amountTarget.value);
        },
        error: (err) => {
          console.log(err);
        }
      })
    }
  }

  changequantity(e) {
    this.numberValue = Number(this.amountTarget.value)
  }




  numberValueChanged() {
    if (this.numberValue !== NaN || this.numberValue != '') {
      this.amountTarget.value = this.numberValue
      this.totalpriceTarget.textContent = Number(this.priceTarget.textContent) * Number(this.amountTarget.value)  
    }
    updateCartTotal()
  }


  add_item(e) {
    const id = this.data.get('id');
    const additemController = document.querySelector('.content')
    const amount = { amount: this.amountTarget.value }
    magicRails.ajax({
      url:  `/carts/add_item/${id}`,
      type: 'post',
      contentType: 'application/json', // 指定傳送到 server 的資料類型
      data: JSON.stringify(amount),
      success: (resp) => {
        console.log(resp, this.amountTarget.value);
      },
      error: (err) => {
        console.log(err);
      }
    })
  }

  destroy(e) {

    const id = this.data.get('id')
    magicRails.ajax({
      url: `/carts/destroy/${id}`,
      type: 'delete',
      success: (resp) => {
        console.log(resp,'success', id)
      },
      error: (err) => {
        console.log(err);
      }
    })
  }

}
