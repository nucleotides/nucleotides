$(document).ready(function()
  {

    $('.score').dataTable({
      "order": [[ 2, "desc" ]]
    });

    $('.key').popover({
      placement: 'right',
      container: 'body',
      trigger: 'hover',
      html: true
      });
  }

);
