import { resetWarningCache } from "prop-types"

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}


document.addEventListener('turbolinks:load', function(){
  const modal = getCookie('modal')
  if (modal) {
    document.querySelector('.modal').remove()
    return
  }

  if (document.querySelector('.X')) {
    const modal = document.querySelector('.modal')
    const word = document.querySelector('.word')
    document.querySelector('.X').addEventListener('click',()=>{
      document.querySelector('.X').remove()
      document.querySelector('.modalicon').style.top='-300px'
      word.style.width='1000px'
      setTimeout(( () => word.style.opacity='0'), 300);
      setTimeout(( () => modal.remove()), 1000);

      var expire_days = 1; // 過期日期(天)
      var d = new Date();
      d.setTime(d.getTime() + (expire_days * 24 * 60 * 60 * 1000));
      var expires = "expires=" + d.toGMTString();
      document.cookie = "modal=1" + "; " + expires + '; path=/';
    })  
  }
})
