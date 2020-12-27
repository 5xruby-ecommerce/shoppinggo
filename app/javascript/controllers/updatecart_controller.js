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
  // carttotal.textContent = items.reduce((total, item) => {total += Number(item.textContent)})
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
        const event = new CustomEvent('plusbtn', {
          detail: {
            count: resp.count,
            total_price: resp.total_price
          }
        })
        window.dispatchEvent(event)
        // document.querySelector('.cartCount').textContent = resp["count"]
        // document.querySelector('.cartTotalPrice').textContent = resp["total_price"]
      },
      error: (err) => {
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
          const event = new CustomEvent('plusbtn', {
            detail: {
              count: resp.count,
              total_price: resp.total_price
            }
          })
          window.dispatchEvent(event)
          // document.querySelector('.cartCount').textContent = resp["count"]
          // document.querySelector('.cartTotalPrice').textContent = resp["total_price"]
        },
        error: (err) => {
        }
      })
    }
  }

  changequantity(e) {
    console.log("target value: ",this.amountTarget.value)
    console.log("number value",this.numberValue)
    const id = this.data.get('id');
    let varyamount = Number(this.amountTarget.value) - this.numberValue 
    console.log(varyamount)
    this.numberValue = Number(this.amountTarget.value) 
    const amount = { amount: varyamount }
    magicRails.ajax({
      url:  `/carts/update_item/${id}`,
      type: 'post',
      contentType: 'application/json', // 指定傳送到 server 的資料類型
      data: JSON.stringify(amount),
      success: (resp) => {
        const event = new CustomEvent('plusbtn', {
          detail: {
            count: resp.count,
            total_price: resp.total_price
          }
        })
        window.dispatchEvent(event)
        // document.querySelector('.cartCount').textContent = resp["count"]
        // document.querySelector('.cartTotalPrice').textContent = resp["total_price"]
      },
      error: (err) => {
      }
    })
  }

  numberValueChanged() {
    if (this.amountTarget.value !== NaN || this.amountTarget.value != '') {
      this.amountTarget.value = this.numberValue
      this.totalpriceTarget.textContent = Number(this.priceTarget.textContent) * Number(this.amountTarget.value)  
    }
    updateCartTotal()
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
