document.addEventListener('turbolinks:load', () => {
  startPicker = flatpickr(".datetimepicker_start", {
    altFormat: "Y/n/j H:i",
    enableTime: true,
    defaultDate: 'today',
    onChange: function(selectedDates, dateStr, instance) {
      endPicker.set('minDate', selectedDates[0]);  
    }
  });
  endPicker = flatpickr(".datetimepicker_end", {
    altFormat: "Y/n/j H:i",
    enableTime: true
  });
})