import Swiper from 'swiper/bundle';
<<<<<<< HEAD

document.addEventListener('turbolinks:load', function(){
  var swiper = new Swiper('.swiper-container', {
    spaceBetween: 30,
    centeredSlides: true,
    autoplay: {
      delay: 2500,
      disableOnInteraction: false,
    },
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });
})

  
=======
console.log("hello")
document.addEventListener('turbolinks:load', function(){
  var swiper = new Swiper('.swiper-container', {
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
    });
})
>>>>>>> 601938dd8645ad88191889284507e5dc0c998743
