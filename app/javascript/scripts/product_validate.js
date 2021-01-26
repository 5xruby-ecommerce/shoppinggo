import { func } from "prop-types";

document.addEventListener('turbolinks:load', () => {
  const name = document.querySelector('#product_name');
  const price = document.querySelector('#product_price');
  const quantity = document.querySelector('#product_quantity');
  const formbtn = document.querySelector('[type=submit] .product');
  const inputform = document.querySelector('.new_product');
  const editform = document.querySelector('.edit_product');
  const form = inputform || editform;
  const validateblank = [name, price, quantity];
  const validatenumber = [price, quantity];

  validateblank.forEach(element => {
    if (element) {
      element.addEventListener('focusout', (e) => {
        const item = e.currentTarget
        if (item.value.trim() == '') {
          item.classList.add('invalid')
          item.nextElementSibling.textContent = '不可為空白'
          item.nextElementSibling.classList.add('error')
        } else {
          item.classList.remove('invalid')  
          item.nextElementSibling.textContent = ''
          item.nextElementSibling.classList.remove('error')
        }
      })  
    }
  });

  validatenumber.forEach(element => {
    if (element) {
      element.addEventListener('focusout', (e) => {
        const item = e.currentTarget
        if (isNaN(parseInt(item.value))) {
          item.classList.add('invalid')
          item.nextElementSibling.textContent = '須為數字'
          item.nextElementSibling.classList.add('error')
        }
      })  
    }
  })

  if (formbtn) {
    formbtn.addEventListener('click', (e)=> {
      e.preventDefault()
  
      if (validateblank.map(el => el.value.trim()).includes('') || (validateblank.map(el => el.classList.contains('invalid'))).includes(true)) {
        validateblank.forEach(element => {
          if (element.value.trim() == '' || element.classList.contains('.invalid') == true) {
            element.classList.add('invalid')
            element.nextElementSibling.textContent = '不可為空白'
            element.nextElementSibling.classList.add('error')
          }
        });
      } else {
        form.submit() 
      }
    })  
  }
})