$(document).ready ->
  $("input.date_picker").datepicker({
    dateFormat: 'yy-mm-dd'
    });

  # http://stackoverflow.com/questions/4987293/weird-jquery-date-picker-action
  $('.datepicker').datepicker('destroy');    
  $('.datepicker').removeClass("hasDatepicker").removeAttr('id');    
  $('.datepicker').datepicker({dateFormat: "yy-mm-dd"});
