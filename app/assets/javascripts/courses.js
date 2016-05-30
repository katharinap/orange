$(document).ready(function() {
  $('#courses-calendar').fullCalendar({
    events: $('#courses-calendar').data('event-url')
  })
  $('#courses-calendar').fullCalendar('option', 'height', 'auto');
  $('#courses-calendar').fullCalendar('option', 'contentHeight', 'auto');
});
