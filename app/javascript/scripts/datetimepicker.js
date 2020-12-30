document.addEventListener('turbolinks:load', () => {
  $('#discount_start').datetimepicker({
    format: 'YYYY/MM/DD'
  })
  $('#discount_end').datetimepicker({
    format: 'YYYY/MM/DD'
  })

  $('#discount_start').on('change.datetimepicker', (e) => {
    $('#discount_end').datetimepicker('minDate', e.date)
  })
  $('#discount_end').on('change.datetimepicker', (e) => {
    $('#discount_start').datetimepicker('maxDate', e.date)
  })
  

})