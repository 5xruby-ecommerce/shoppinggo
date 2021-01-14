import { Controller } from "stimulus"
import magicRails from '@rails/ujs'

export default class extends Controller {
  static targets = [ "amount", "coupon"]
  static values = { number: Number, 
                    coupon: Number
                  }
 
  connect() {
    console.log('add item')
    this.numberValueChanged()
  }

  plusbtn(e) {
    this.numberValue++
  }

  minusbtn(e) {
    if (this.amountTarget.value >= 2) {
      this.numberValue--;
    }
  }

  changequantity(e) {
    this.numberValue = Number(this.amountTarget.value)
  }

  numberValueChanged() {
    if (isNaN(this.numberValue) || this.numberValue != '') {
      this.amountTarget.value = this.numberValue
    }
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
      // data: new URLSearchParams(amount).toString(),
      success: (resp) => {
        console.log(resp, this.amountTarget.value);
      },
      error: (err) => {
        console.log(err);
      }
    })
  }

  getcoupon(e) {
    if (e.currentTarget.getAttribute('class').split(' ').includes('occupy')) {
      e.preventDefault()
    } else {
      const coupon = e.target
      const couponID = coupon.getAttribute('data-couponid')
      const key = { coupon_key: couponID }
  
      // first check whether the user own the coupon by check database
      magicRails.ajax({
        url: `carts/get_coupon_info/${couponID}`,
        type: 'get',
        success: (resp) => {
  
          const occupy = resp['occupy']
          const amount = resp['amount']
          const counterCatch = resp['counter_catch']
  
          if (occupy === false) {
            if (amount > counterCatch) {
              // if the user doese not own the coupon and the coupons haven't been run out, then user can occupy the coupon
              magicRails.ajax({
                url: `/users/add_coupon`,
                type: 'post',
                contentType: 'application/json',
                data: JSON.stringify(key),
                success: (resp) => {
                  if (!coupon.classList.contains('occupy')) {
                    console.log('get it')
                    coupon.classList.add('occupy')
                  } else {
                    console.log('already get it')
                  }
                },
                error: (err) => {
                  console.log(err)
                }
              })
            } else {
              console.log('the coupon has already been run out')
            }
          } else {
            console.log('you have already owned the coupon')
          }
        },
        error: (err) => {
          console.log(err)
        }
      })  
    }
  }
}
