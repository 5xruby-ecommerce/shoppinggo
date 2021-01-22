document.addEventListener('turbolinks:load',()=>{
  const emailRule = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z]+$/
  document.querySelector('.email').addEventListener('focusout',checkemail)
  document.querySelector('.password').addEventListener('focusout',check)
  document.querySelector('.confirm').addEventListener('focusout',confirm)


  function checkemail (e){
    const email = document.querySelector('.email').value
    const emailval = e.target.value
    if (email == ""){
      document.querySelector('.login_notice').innerText="* 欄位不能空白"
      document.querySelector('.email').parentElement.classList.add('notice')
    }else if (emailval.search(emailRule)!= -1){
        document.querySelector('.login_notice').innerText=""
        document.querySelector('.email').parentElement.classList.remove('notice')
      }else{
        document.querySelector('.login_notice').innerText="* email格式錯誤"
    }
  }

  function check (e){
    const check_value = e.target.value
    const item = e.target
    if (check_value == ""){
      document.querySelector('.login_notice').innerText="* 欄位不能空白"
      item.parentElement.classList.add('notice')
    }else if(check_value.length < 6){
      document.querySelector('.login_notice').innerText="* 密碼必須至少6個字元"
    }else{
      item.parentElement.classList.remove('notice')
    }
  }

  function confirm (e){
    const pw_confirm = e.target.value
    const pw = document.querySelector('.password').value
    console.log(pw_confirm)
    if(pw_confirm !== ""){
      if(pw_confirm !== pw){
        document.querySelector('.login_notice').innerText="* 密碼不一致"
        item.parentElement.classList.add('notice')
      }else{
        item.parentElement.classList.remove('notice')
      }
    }
  }

})
