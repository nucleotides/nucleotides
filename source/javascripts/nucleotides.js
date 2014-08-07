$(document).ready(function()

  {
    $(".score").tablesorter({
      sortList: [[2,1]],
      cssAsc: 'bg-primary',
      cssDesc: 'bg-primary'
    });

    $('.key').popover({
      placement: 'right',
      container: 'body',
      trigger: 'hover',
      html: true
      });
  }

);
