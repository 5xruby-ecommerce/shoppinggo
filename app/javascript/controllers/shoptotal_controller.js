import { Controller } from "stimulus"
import magicRails from '@rails/ujs'

export default class extends Controller {
  static targets = ["shoptotal"]

  update(e) {
    e.preventDefault()
    const {count, total_price, shoptotal} = e.detail
    this.shoptotalTarget.innerText = `${shoptotal}`
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
              document.querySelector(`span[data-couponid="${couponID}"]`).classList.add('occupy')
      
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
    const itemTotalPrice= e.currentTarget.parentNode.parentNode.parentNode.querySelectorAll('.item_total_price');    
    const shopID = this.data.get('id') // the shop ID of the select coupon 
    const couponID = e.currentTarget.getAttribute('data-couponid'); // the coupon ID of the select coupon
    const itemsTotalPrice = document.querySelectorAll(`div[data-controller="updatecart"]>div[data-shopid="${shopID}"]`); // select all product's total price of the shop
    const coupons = (e.currentTarget.parentNode.parentNode.querySelectorAll('span')); // select all coupons of the shop
    const clickedbtn = e.currentTarget; // select the clicked coupon

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
        const usercoupon_id = resp['usercoupon_id'][0]
        console.log(resp['status'])
        if (occupy == true) {
          const status = resp['status'][0]
          if (status == 'unused') {

            // calculate the total price of the shop
            let cartShopTotalprice = 0;
            itemsTotalPrice.forEach((e) =>{
              cartShopTotalprice += Number(e.innerHTML)
            })

            console.log(counterCatch)
            console.log(amount)
            console.log(cartShopTotalprice)
            console.log(minConsumption)
            // First check whether it satisfy the rule of the coupon
            if (counterCatch < amount && cartShopTotalprice > minConsumption) {
              // check which rule it is
              if (rule == "dollor") {
                // direct minus the discountAmount of the coupon to the cart total price 
                document.querySelector('.cart_total').textContent -= discountAmount
                document.querySelector('.cartTotalPrice').textContent -= discountAmount
              } else if (rule == 'percent') {
                // if its rule is percent, first calculate the discount dollar based on the total price of the shop(note: not the cart total price, is the shop total price)
                // then minus the discount dollar to the cart total price
                let discountDollor = Math.floor(cartShopTotalprice * discountAmount * 0.01)
                document.querySelector('.cart_total').textContent = Number(document.querySelector('.cart_total').textContent) - discountDollor
                document.querySelector('.cartTotalPrice').textContent = Number(document.querySelector('.cartTotalPrice').textContent) - discountDollor
              }
              // if the coupon is used, then add class tag to it to ensure it is not clickable
              clickedbtn.classList.add('occupy')

              // change usercoupon state to 'used'
              const usercouponID = {usercouponID: usercoupon_id}
              magicRails.ajax({
                url: `/users/change_coupon_status`,
                type: 'get',
                data: JSON.stringify(usercouponID),
                success: (resp) => {
                  console.log(resp)
                  // it is for broadcasting to thoses who listen to the usecoupon action
                  const cartShopProductsNumber = document.querySelectorAll(`div[data-updatecart-target="totalprice"]`)
                  const event = new CustomEvent('usecoupon', {
                    detail: {
                      count: cartShopProductsNumber.length,
                      cart_total: resp['cart_total'].to_i
                    }
                  })
                  window.dispatchEvent(event)
                  // const msg = {usercouponID: usercoupon_id, couponStatus: 'use'}
                  // // calculate the total price of all shops
                  // magicRails.ajax({
                  //   url: `/carts/cal_totalprice`,
                  //   type: 'get',
                  //   data: JSON.stringify(msg),
                  //   success: (resp) => {
                  //     console.log(resp)
                  //   },
                  //   error: (err) => {
                  //     console.log(err)
                  //   }
                  // })
                },
                error: (err) => {
                  console.log(err)
                }
              })
              clickedbtn.textContent = '使用中'
            } else {
              console.log('未達使用Coupon條件')
            }
            console.log(itemTotalPrice.length)
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

    const coupon = e.currentTarget.parentNode.querySelector('div')
    if (coupon.textContent.trim() == "使用中") {

      const shopID = coupon.getAttribute('data-shopid')
      const itemTotalPrice= e.currentTarget.parentNode.parentNode.parentNode.querySelectorAll('.item_total_price');   // select all product's total price of the shop        
      const couponID = coupon.getAttribute('data-couponid')
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
          if (occupy == true) {
            if (status === 'used') {
                // query all products of the shop
              const cartShopProductsNumber = document.querySelectorAll(`div[data-updatecart-target="totalprice"]`); 
                // calculate the total price of the shop
              let cartShopTotalprice = 0;
              itemTotalPrice.forEach((e) =>{
                cartShopTotalprice += Number(e.innerHTML)
              })

                // First check whether it satisfy the rule of the coupon
              if (counterCatch < amount && cartShopTotalprice > minConsumption) {
                  // check which rule it is
                if (rule == "dollor") {
                  // direct minus the discountAmount of the coupon to the cart total price 
                  document.querySelector('.cart_total').textContent = Number(document.querySelector('.cart_total').textContent) + discountAmount
                  document.querySelector('.cartTotalPrice').textContent = Number(document.querySelector('.cartTotalPrice').textContent) + discountAmount
                } else if (rule == 'percent') {
                  // if its rule is percent, first calculate the discount dollar based on the total price of the shop(note: not the cart total price, is the shop total price)
                    // then minus the discount dollar to the cart total price
                  let discountDollor = Math.floor(cartShopTotalprice * discountAmount * 0.01)
                  document.querySelector('.cart_total').textContent = Number(document.querySelector('.cart_total').textContent) + discountDollor
                  document.querySelector('.cartTotalPrice').textContent = Number(document.querySelector('.cartTotalPrice').textContent) +  discountDollor
                }

                  // change usercoupon state to 'unused'
                const usercouponID = {usercouponID: usercoupon_id}
                magicRails.ajax({
                  url: `/users/change_coupon_status`,
                  type: 'get',
                  data: JSON.stringify(usercouponID),
                  success: (resp) => {
                    console.log(resp)
                    console.log('change coupon status')
                    coupon.classList.remove('occupy')
                    coupon.textContent = "未使用"
                    // const msg = {usercouponID: usercoupon_id, couponStatus: 'unuse'}
                    // console.log(msg)
                    // // calculate the total price of the cart
                    // magicRails.ajax({
                    //   url: `/carts/cal_totalprice`,
                    //   type: 'get',
                    //   data: JSON.stringify(msg),
                    //   success: (resp) => {
                    //     console.log(resp)
                    //   },
                    //   error: (err) => {
                    //     console.log(err)
                    //   }
                    // })
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
  }
}
