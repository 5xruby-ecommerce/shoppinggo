document.addEventListener('turbolinks:load', () => {
  startPicker = flatpickr(".datetimepicker_start_edit", {
    altFormat: "Y/n/j H:i",
    enableTime: true,
    onChange: function(selectedDates, dateStr, instance) {
      endPicker.set('minDate', selectedDates[0]);  
    }
  });
  endPicker = flatpickr(".datetimepicker_end_edit", {
    altFormat: "Y/n/j H:i",
    enableTime: true
  });
})