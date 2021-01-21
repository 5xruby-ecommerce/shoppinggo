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
  static targets = [ "amount", "totalprice" , "price" ]
  static values = { number: Number, totalprice: Number }

  connect() {
    this.numberValueChanged()
  }

  plusbtn(e) {
    this.numberValue++
    const id = this.data.get('id');
    const amount = { amount: 1 }
    magicRails.ajax({
      url:  `/carts/update_item/${id}`,
      type: 'put',
      contentType: 'application/json', // 指定傳送到 server 的資料類型
      data: JSON.stringify(amount),
      success: (resp) => { 
        const shopID = resp['shopID']
        document.querySelector(`span[data-shoptotal-target="shoptotal"][data-shopid="${shopID}"]`).textContent = resp.shoptotal
        const event = new CustomEvent('plusbtn', {
          detail: {
            count: resp.count,
            total_price: resp.total_price,
            shoptotal: resp.shoptotal
          }
        })
        window.dispatchEvent(event)
      },
      error: (err) => {
      }
    })
  }

  minusbtn(e) {
    if (this.amountTarget.value >= 2) {
      this.numberValue--;

      const id = this.data.get('id');
      const amount = { amount: -1 }

      magicRails.ajax({
        url:  `/carts/update_item/${id}`,
        type: 'put',
        contentType: 'application/json', // 指定傳送到 server 的資料類型
        data: JSON.stringify(amount),
        success: (resp) => {
          const shopID = resp['shopID']
          document.querySelector(`span[data-shoptotal-target="shoptotal"][data-shopid="${shopID}"]`).textContent = resp.shoptotal
          const event = new CustomEvent('minusbtn', {
            detail: {
              count: resp.count,
              total_price: resp.total_price,
              shoptotal: resp.shoptotal
            }
          })
          window.dispatchEvent(event)
        },
        error: (err) => {
          console.log(err)
        }
      })
    }
  }

  changequantity(e) {
    const id = this.data.get('id');
    let varyamount = Number(this.amountTarget.value) - this.numberValue 
    this.numberValue = Number(this.amountTarget.value) 
    const amount = { amount: varyamount }
    console.log(id, varyamount, amount)
    magicRails.ajax({
      url:  `/carts/update_item/${id}`,
      type: 'put',
      contentType: 'application/json', // 指定傳送到 server 的資料類型
      data: JSON.stringify(amount),
      success: (resp) => {
        const shopID = resp['shopID']
        document.querySelector(`span[data-shoptotal-target="shoptotal"][data-shopid="${shopID}"]`).textContent = resp.shoptotal
        const event = new CustomEvent('changequantity', {
          detail: {
            count: resp.count,
            total_price: resp.total_price,
            shoptotal: resp.shoptotal
          }
        })
        window.dispatchEvent(event)
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

  getcoupon(e) {
    if (e.currentTarget.getAttribute('class').split(' ').includes('opacity')) {
      e.preventDefault()
    } else {
      const couponID = e.currentTarget.getAttribute('data-couponid');
      const totalPrice= e.currentTarget.parentNode.parentNode.previousSibling.previousSibling.previousSibling.previousSibling.querySelector('.item_total_price');
      const shopID = totalPrice.getAttribute('data-shopid');
  
      magicRails.ajax({
        url: `/carts/get_coupon_info/${couponID}`,
        type: 'get',
        success: (resp) => {

          const amount = resp['amount'];
          const counterCatch = resp['counter_catch'];
          const occupy = resp['occupy'];

          if (occupy === false ) {
            if (amount > counterCatch) {
              // change backgroun color after clicked
              document.querySelector(`a[data-couponid="${couponID}"]`).classList.add('occupy')
      
              const key = { coupon_key: couponID }
              magicRails.ajax({
                url: `/users/add_coupon`,
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(key),
                success: (resp) => {
                  console.log(resp)
                },
                error: (err) => {
                  console.log(err)
                }
              })            
            } else {
              console.log('該優惠卷已經被領取完')
            }
          } else {
            console.log('你已經擁有此優惠卷')
          }
        },
        error: (err) => {
          console.log(err);
        }
      })
        
    }
  }
}
