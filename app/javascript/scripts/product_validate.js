import { func } from "prop-types";

document.addEventListener('turbolinks:load', () => {
  const name = document.querySelector('#product_name');
  const price = document.querySelector('#product_price');
  const quantity = document.querySelector('#product_quantity');
  const inputform = document.querySelector('#new_product');
  const validateinput = [name, price, quantity]
  validateinput.forEach(element => {
    element.addEventListener('focusout', (e) => {
      const item = e.currentTarget
      if (item.value.trim() == '') {
        item.classList.add('invalid')
      } else {
        item.classList.remove('invalid')  
      }
    })
  });

  inputform.addEventListener('click', (e)=> {
    e.preventDefault()

    if (validateinput.map(el => el.value.trim()).includes('') || (validateinput.map(el => el.classList.contains('invalid'))).includes(true)) {
      validateinput.forEach(element => {
        if (element.value.trim() == '' || element.classList.contains('.invalid') == true) {
          element.classList.add('invalid')
        }
      });
    } else {
      inputform.submit() 
    }
  })
})