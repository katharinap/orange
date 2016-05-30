$(document).ready(function() {
  $('#courses-calendar').fullCalendar({
    events: $('#courses-calendar').data('event-url')
  })
});
