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
      type: 'post',
      contentType: 'application/json', // 指定傳送到 server 的資料類型
      data: JSON.stringify(amount),
      success: (resp) => {
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
        type: 'post',
        contentType: 'application/json', // 指定傳送到 server 的資料類型
        data: JSON.stringify(amount),
        success: (resp) => {
          console.log(resp)
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

  usecoupon(e) {
    const itemTotalPrice= e.currentTarget.parentNode.parentNode.previousSibling.previousElementSibling.previousElementSibling.querySelector('.item_total_price');
    const shopID = itemTotalPrice.getAttribute('data-shopid'); // the shop ID of the select coupon 
    const couponID = e.currentTarget.getAttribute('data-couponid'); // the coupon ID of the select coupon
    const itemsTotalPrice = document.querySelectorAll(`td[data-shopid="${shopID}"]`); // select all product's total price of the shop
    const coupons = (e.currentTarget.parentNode.querySelectorAll('span')); // select all coupons of the shop
    const clickedbtn = e.currentTarget; // select the clicked coupon

    magicRails.ajax({
      url: `/carts/get_coupon_info/${couponID}`,
      type: 'get',
      success: (resp) => {
        console.log(resp)
        const rule = resp['discount_rule']
        const discountStart = resp['discount_start']
        const discountEnd = resp['discount_end']
        const minConsumption = resp['min_consumption']
        const amount = resp['amount']
        const counterCatch = resp['counter_catch']
        const discountAmount = resp['discount_amount']
        const occupy = resp['occupy']
        const usercoupon_id = resp['usercoupon_id'][0]

        if (occupy == true) {
          const status = resp['status'][0]
          if (status == 'unused') {

            // query all products of the shop
            const cartShopProductsNumber = document.querySelectorAll(`td[data-updatecart-target="totalprice"]`); 
            // calculate the total price of the shop
            let cartShopTotalprice = 0;
            itemsTotalPrice.forEach((e) =>{
              cartShopTotalprice += Number(e.innerHTML)
            })
    
            // First check whether it satisfy the rule of the coupon
            if (counterCatch < amount && cartShopTotalprice > minConsumption) {
              // check which rule it is
              if (rule == "dollor") {
                // direct minus the discountAmount of the coupon to the cart total price 
                document.querySelector('.cart_total').textContent -= discountAmount
              } else if (rule == 'percent') {
                // if its rule is percent, first calculate the discount dollar based on the total price of the shop(note: not the cart total price, is the shop total price)
                // then minus the discount dollar to the cart total price
                let discountDollor = Math.floor(cartShopTotalprice * discountAmount * 0.01)
                document.querySelector('.cart_total').textContent -= discountDollor
              }
              // if the coupon is used, then add class tag to it to ensure it is not clickable
              document.querySelector(`[data-couponid="${couponID}"]`).classList.add('occupy')
              coupons.forEach(el => {
                  el.classList.add('occupy')
              })

              // change usercoupon state to 'used'
              const usercouponID = {usercouponID: usercoupon_id}
              magicRails.ajax({
                url: `/users/change_coupon_status`,
                type: 'get',
                data: JSON.stringify(usercouponID),
                success: (resp) => {
                  const msg = {usercouponID: usercoupon_id, couponStatus: 'use'}
                  // calculate the total price of all shops
                  magicRails.ajax({
                    url: `/carts/cal_totalprice`,
                    type: 'get',
                    data: JSON.stringify(msg),
                    success: (resp) => {
                      console.log(resp)
                    },
                    error: (err) => {
                      console.log(err)
                    }
                  })
                },
                error: (err) => {
                  console.log(err)
                }
              })
              clickedbtn.textContent = '使用中'
            } else {
              console.log('未達使用Coupon條件')
            }
            
            // it is for broadcasting to thoses who listen to the usecoupon action
            const event = new CustomEvent('usecoupon', {
              detail: {
                count: cartShopProductsNumber.length,
                total_price: document.querySelector('.cart_total').textContent
              }
            })
            window.dispatchEvent(event)
          } else {
            console.log('你已經使用過該優惠卷')
          }
        } else if (status == "used") {
          console.log('你還未領取該優惠卷')
        }
      },
      error: (err) => {
        console.log(err);
      }
    })  
  }

  unusecoupon(e) {
    const coupons = (e.currentTarget.parentNode.querySelectorAll('span')) // select all coupons of the shop
    
    coupons.forEach(el => {
      if (el.textContent == "使用中") {
        const itemTotalPrice= el.parentNode.parentNode.previousSibling.previousElementSibling.previousElementSibling.querySelector('.item_total_price')
        const shopID = itemTotalPrice.getAttribute('data-shopid'); // the shop ID of the select coupon 
        const itemsTotalPrice = document.querySelectorAll(`td[data-shopid="${shopID}"]`) // select all product's total price of the shop        
        const couponID = el.getAttribute('data-couponid')
        
        magicRails.ajax({
          url: `/carts/get_coupon_info/${couponID}`,
          type: 'get',
          success: (resp) => {
            const rule = resp['discount_rule']
            const discountStart = resp['discount_start']
            const discountEnd = resp['discount_end']
            const minConsumption = resp['min_consumption']
            const amount = resp['amount']
            const counterCatch = resp['counter_catch']
            const discountAmount = resp['discount_amount']
            const occupy = resp['occupy']
            const status = resp['status'][0]
            const usercoupon_id = resp['usercoupon_id'][0]

            console.log(status)
            if (occupy == true) {
              if (status === 'used') {
                // query all products of the shop
                const cartShopProductsNumber = document.querySelectorAll(`td[data-updatecart-target="totalprice"]`); 
                // calculate the total price of the shop
                let cartShopTotalprice = 0;
                itemsTotalPrice.forEach((e) =>{
                  cartShopTotalprice += Number(e.innerHTML)
                })

                // First check whether it satisfy the rule of the coupon
                if (counterCatch < amount && cartShopTotalprice > minConsumption) {
                  // check which rule it is
                  if (rule == "dollor") {
                    // direct minus the discountAmount of the coupon to the cart total price 
                    document.querySelector('.cart_total').textContent = Number(document.querySelector('.cart_total').textContent) + discountAmount
                  } else if (rule == 'percent') {
                    // if its rule is percent, first calculate the discount dollar based on the total price of the shop(note: not the cart total price, is the shop total price)
                    // then minus the discount dollar to the cart total price
                    let discountDollor = Math.floor(cartShopTotalprice * discountAmount * 0.01)
                    document.querySelector('.cart_total').textContent = Number(document.querySelector('.cart_total').textContent) + discountDollor
                  }

                  // change usercoupon state to 'unused'
                  const usercouponID = {usercouponID: usercoupon_id}
                  magicRails.ajax({
                    url: `/users/change_coupon_status`,
                    type: 'get',
                    data: JSON.stringify(usercouponID),
                    success: (resp) => {
                      const msg = {usercouponID: usercoupon_id, couponStatus: 'unuse'}
                      // calculate the total price of the cart
                      magicRails.ajax({
                        url: `/carts/cal_totalprice`,
                        type: 'get',
                        data: JSON.stringify(msg),
                        success: (resp) => {
                          console.log(resp)
                        },
                        error: (err) => {
                          console.log(err)
                        }
                      })
                    },
                    error: (err) => {
                      console.log('err')
                    }
                  })
                }

                // it is for broadcasting to thoses who listen to the usecoupon action
                const event = new CustomEvent('unusecoupon', {
                  detail: {
                    count: cartShopProductsNumber.length,
                    total_price: document.querySelector('.cart_total').textContent
                  }
                })
                window.dispatchEvent(event)
              } else {
                console.log('你尚未使用此優惠卷')
              }
            } else {
              console.log('你尚未擁有此優惠卷')
            }
          },
          error: (err) => {
            console.log(err);
          }
        })
      }
    })

    coupons.forEach(el => {
      el.classList.remove('occupy')
      el.textContent = "未使用"
    })

  }
}
