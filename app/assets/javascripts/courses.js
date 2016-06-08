$(document).ready(function() {
  $('#courses-calendar').fullCalendar({
    firstDay: 1,
    events: $('#courses-calendar').data('event-url'),
    eventClick: function(calEvent, jsEvent, view) {
      $.ajax({ url: calEvent.edit_url })
    },
    eventRender: function(event, element) {
      element.qtip({
	content: {
          text: event.tip,
	},
	style: {
	  classes: 'qtip qtip-bootstrap'
	}
      });
    }
  })
  $('#courses-calendar').fullCalendar('option', 'height', 'auto');
  $('#courses-calendar').fullCalendar('option', 'contentHeight', 'auto');
});
