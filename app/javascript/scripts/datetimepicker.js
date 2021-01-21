import flatpickr from "flatpickr"

document.addEventListener('turbolinks:load', () => {

  flatpickr(".datetimepicker_start", {
    "dateFormat":"Y/n/j H:i", 
    "enableTime":true, 
    "allowInput":true,
    onClose: function(dataObj, dateStr, instance) {      
    }
  })
  flatpickr(".datetimepicker_end", {
    "dateFormat":"Y/n/j H:i", 
    "enableTime":true, 
    "allowInput":true,
    onClose: function(dataObj, dateStr, instance) {
    }
  })
})