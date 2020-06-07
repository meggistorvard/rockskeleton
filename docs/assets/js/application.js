/* */

!function ($) {

  $(function(){

    // Disable certain links in docs
    $('section [href^=#]').click(function (e) {
      e.preventDefault()
    })

    // make code pretty
    window.prettyPrint && prettyPrint()

    // add-ons
    $('.rock-add-on :checkbox').on('click', function () {
      var $this = $(this)
        , method = $this.attr('checked') ? 'addClass' : 'removeClass'
      $(this).parents('.rock-add-on')[method]('active')
    })

    // add tipsies to grid for scaffolding
    if ($('#rock-grid-system').length) {
      $('#rock-grid-system').tooltip({
          selector: '.rock-show-grid > div'
        , title: function () { return $(this).width() + 'px' }
      })
    }

    // fix sub nav on scroll
    var $win = $(window)
      , $nav = $('.rock-subnavmenu')
      , navTop = $('.rock-subnavmenu').length && $('.rock-subnavmenu').offset().top - 40
      , isFixed = 0

    processScroll()

    $win.on('scroll', processScroll)

    function processScroll() {
      var i, scrollTop = $win.scrollTop()
      if (scrollTop >= navTop && !isFixed) {
        isFixed = 1
        $nav.addClass('rock-subnavmenu-fixed')
      } else if (scrollTop <= navTop && isFixed) {
        isFixed = 0
        $nav.removeClass('rock-subnavmenu-fixed')
      }
    }

    // tooltip demo
    $('.rock-tooltip-demo.rock-well').tooltip({
      selector: "a[rel=rock-tooltip]"
    })

    $('.rock-tooltip-test').tooltip()
    $('.rock-popover-test').popover()

    // popover demo
    $("a[rel=rock-popover]")
      .popover()
      .click(function(e) {
        e.preventDefault()
      })

    // button state demo
    $('#rock-fat-button')
      .click(function () {
        var btn = $(this)
        btn.button('loading')
        setTimeout(function () {
          btn.button('reset')
        }, 3000)
      })

    // carousel demo
    $('#rock-myCarousel').carousel()

    // javascript build logic
    var inputsComponent = $("#rock-components.download input")
      , inputsPlugin = $("#rock-plugins.download input")
      , inputsVariables = $("#rock-variables.download input")

    // toggle all plugin checkboxes
    $('#rock-components.download .rock-toggle-all').on('click', function (e) {
      e.preventDefault()
      inputsComponent.attr('checked', !inputsComponent.is(':checked'))
    })

    $('#rock-plugins.download .rock-toggle-all').on('click', function (e) {
      e.preventDefault()
      inputsPlugin.attr('checked', !inputsPlugin.is(':checked'))
    })

    $('#rock-variables.download .rock-toggle-all').on('click', function (e) {
      e.preventDefault()
      inputsVariables.val('')
    })

    // request built javascript
    $('.rock-download-btn').on('click', function () {

      var css = $("#rock-components.download input:checked")
            .map(function () { return this.value })
            .toArray()
        , js = $("#rock-plugins.download input:checked")
            .map(function () { return this.value })
            .toArray()
        , vars = {}
        , img = ['glyphicons-halflings.png', 'glyphicons-halflings-white.png']

    $("#rock-variables.download input")
      .each(function () {
        $(this).val() && (vars[ $(this).prev().text() ] = $(this).val())
      })

      $.ajax({
        type: 'POST'
      , url: 'http://rockskeleton.herokuapp.com'
      , dataType: 'jsonpi'
      , params: {
          branch: '2.0-wip'
        , js: js
        , css: css
        , vars: vars
        , img: img
      }
      })
    })

  })

// Modified from the original jsonpi https://github.com/benvinegar/jquery-jsonpi
$.ajaxTransport('jsonpi', function(opts, originalOptions, jqXHR) {
  var url = opts.url;

  return {
    send: function(_, completeCallback) {
      var name = 'jQuery_iframe_' + jQuery.now()
        , iframe, form

      iframe = $('<iframe>')
        .attr('name', name)
        .appendTo('head')

      form = $('<form>')
        .attr('method', opts.type) // GET or POST
        .attr('action', url)
        .attr('target', name)

      $.each(opts.params, function(k, v) {

        $('<input>')
          .attr('type', 'hidden')
          .attr('name', k)
          .attr('value', typeof v == 'string' ? v : JSON.stringify(v))
          .appendTo(form)
      })

      form.appendTo('body').submit()
    }
  }
})

}(window.jQuery)