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
    document.querySelector('.X').addEventListener('click',()=>{
      document.querySelector('.modal').remove()
      var expire_days = 1; // 過期日期(天)
      var d = new Date();
      d.setTime(d.getTime() + (expire_days * 24 * 60 * 60 * 1000));
      var expires = "expires=" + d.toGMTString();
      document.cookie = "modal=1" + "; " + expires + '; path=/';
    

      

    })  
  }
})

// 先顯示廣告
// 使用者點擊按鈕後
// 將此事件存進cookie
// 過了一小時在cookie reset