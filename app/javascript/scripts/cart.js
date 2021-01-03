import magicRails from '@rails/ujs'

document.addEventListener("DOMContentLoaded", () => {

 document.querySelectorAll('.quantity').forEach(input=>{
    input.addEventListener('change',subTotal)
  })
  document.querySelectorAll('.remove').forEach(btn=>{
    btn.addEventListener('click',()=>{
      btn.parentElement.parentElement.remove()
      cartTotal()
    })
  })
  function subTotal(e){
    const input = e.target.parentElement.parentElement
    const quantity = input.querySelector('.quantity').value
    const price = input.querySelector('.price').innerText
    const id = input.querySelector('.id').innerText
    if(quantity <= 0){
      input.querySelector('.quantity').value = 1
    } 
    input.querySelector('.subtotal').innerText=`${price*quantity}`
    cartTotal()
    
    let amount = input.querySelector('.quantity').value 
    magicRails.ajax({
      url:  `/carts/update_quantity`,
      type: 'post',
      contentType: 'application/json', // 指定傳送到 server 的資料類型
      data: {id: id, amount: amount},
      success: (resp) => {
        // console.log(resp, this.amountTarget.value);
      },
      error: (err) => {
        console.log(err);
      }
    })

  }

  function cartTotal(){
    let total = 0
    const item = document.querySelectorAll('.cart_item').forEach(item =>{
      const subtotal = item.querySelector('.subtotal').innerText
      total += (subtotal * 1)
    })
    document.querySelector('.total').innerText=`${total}`
  }

})
