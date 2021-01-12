document.addEventListener("DOMContentLoaded", () => {
  plusbtn = document.querySelector(".plus");
  minusbtn = document.querySelector(".minus");
  amount = document.querySelector(".inputamount");
  cart = document.querySelector(".cart-btn");

  plusbtn.addEventListener('click', () => {
    amount.value = parseInt(amount.value) + 1;
  })
  minusbtn.addEventListener('click', () => {
    if (parseInt(amount.value) >= 2) {
      amount.value = parseInt(amount.value) - 1;
    }
  })

  
})