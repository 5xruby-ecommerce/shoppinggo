document.addEventListener('turbolinks:load', () => {
  startPicker = flatpickr(".datetimepicker_start", {
    altFormat: "Y/n/j H:i",
    enableTime: true,
    defaultDate: 'today'
  });
  endPicker = flatpickr(".datetimepicker_end", {
    altFormat: "Y/n/j H:i",
    enableTime: true
  });
})