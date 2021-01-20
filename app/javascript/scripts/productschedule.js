document.addEventListener('turbolinks:load', () => {
  // $(function () {
  //   $('#schedule_start').datetimepicker({
  //   });
  //   $('#schedule_end').datetimepicker({
  //     useCurrent: false //Important! See issue #1075
  //   });
  //   $("#schedule_start").on("dp.change", function (e) {
  //     $('#schedule_end').data("DateTimePicker").minDate(e.date);
  //   });
  //   $("#schedule_end").on("dp.change", function (e) {
  //     $('#schedule_start').data("DateTimePicker").maxDate(e.date);
  //   });
  // });
  // document.addEventListener('turbolinks:load', () => {
  //   $('#discount_start').datetimepicker({
  //   })
  //   $('#discount_end').datetimepicker({
  //     useCurrent: false
  //   })
  
  //   $('#discount_start').on('change.datetimepicker', (e) => {
  //     $('#discount_end').datetimepicker('minDate', e.date)
  //   })
  //   $('#discount_end').on('change.datetimepicker', (e) => {
  //     $('#discount_start').datetimepicker('maxDate', e.date)
  //   })
  // })
  $(function () {
    $('#datetimepicker7').datetimepicker();
    $('#datetimepicker8').datetimepicker({
        useCurrent: false
    });
    $("#datetimepicker7").on("change.datetimepicker", function (e) {
        $('#datetimepicker8').datetimepicker('minDate', e.date);
    });
    $("#datetimepicker8").on("change.datetimepicker", function (e) {
        $('#datetimepicker7').datetimepicker('maxDate', e.date);
    });
});
})