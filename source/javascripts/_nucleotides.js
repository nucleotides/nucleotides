$(document).ready(function()
  {

    $('.score').dataTable();

    $('.key').popover({
      placement: 'right',
      container: 'body',
      trigger: 'hover',
      html: true
      });
  }

);
