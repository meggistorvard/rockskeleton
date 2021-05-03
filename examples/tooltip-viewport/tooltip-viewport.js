$(document).ready(function () {
  $('.rock-tooltip-right').tooltip({
    placement: 'right',
    viewport: {selector: 'body', padding: 2}
  })
  $('.rock-tooltip-bottom').tooltip({
    placement: 'bottom',
    viewport: {selector: 'body', padding: 2}
  })
  $('.rock-tooltip-viewport-right').tooltip({
    placement: 'right',
    viewport: {selector: '.rock-container-viewport', padding: 2}
  })
  $('.rock-tooltip-viewport-bottom').tooltip({
    placement: 'bottom',
    viewport: {selector: '.rock-container-viewport', padding: 2}
  })
})
