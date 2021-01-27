import { resetWarningCache } from "prop-types"

document.addEventListener('turbolinks:load', function(){
  const hello = document.cookie
  const h = hello.split(';')
  const o = h[1] ? h[1].split('=') : []
  console.log(o)
  if (o.length > 0 && o[1] == 1) {
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
