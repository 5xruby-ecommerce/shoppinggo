document.addEventListener('turbolinks:load', () => {
  $('#discount_start').datetimepicker({
    format: 'yyyy/MM/DD/HH:mm'
  })
  $('#discount_end').datetimepicker({
    format: 'yyyy/MM/DD/HH:mm',
    useCurrent: false
  })

  $('#discount_start').on('change.datetimepicker', (e) => {
    $('#discount_end').datetimepicker('minDate', e.date)
  })
  $('#discount_end').on('change.datetimepicker', (e) => {
    $('#discount_start').datetimepicker('maxDate', e.date)
  })
})