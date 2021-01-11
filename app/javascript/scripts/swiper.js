import Swiper from 'swiper/bundle';
console.log("hello")
document.addEventListener('turbolinks:load', function(){
  var swiper = new Swiper('.swiper-container', {
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
    });
})