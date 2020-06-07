/* ========================================================
 * rockskeleton-tab.js v1.0.0
 * https://github.com/eugenetcs/rockskeleton/javascript.html#tabs
 * ========================================================
 * Copyright 2018 TCS
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================== */


!function( $ ){

  "use strict"

 /* TAB CLASS DEFINITION
  * ==================== */

  var Tab = function ( element ) {
    this.element = $(element)
  }

  Tab.prototype = {

    constructor: Tab

  , show: function () {
      var $this = this.element
        , $ul = $this.closest('ul:not(.rock-dropdown-menu)')
        , selector = $this.attr('data-target')
        , previous
        , $target

      if (!selector) {
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
      }

      if ( $this.parent('li').hasClass('rock-active') ) return

      previous = $ul.find('.rock-active a').last()[0]

      $this.trigger({
        type: 'show'
      , relatedTarget: previous
      })

      $target = $(selector)

      this.activate($this.parent('li'), $ul)
      this.activate($target, $target.parent(), function () {
        $this.trigger({
          type: 'shown'
        , relatedTarget: previous
        })
      })
    }

  , activate: function ( element, container, callback) {
      var $active = container.find('> .rock-active')
        , transition = callback && $.support.transition && $active.hasClass('rock-fade')

      function next() {
        $active
          .removeClass('rock-active')
          .find('> .rock-dropdown-menu > .rock-active')
          .removeClass('rock-active')

        element.addClass('rock-active')

        if (transition) {
          element[0].offsetWidth // reflow for transition
          element.addClass('rock-in'); 
        } else {
          element.removeClass('rock-fade');
        }

        if ( element.parent('.rock-dropdown-menu') ) {
          element.closest('li.rock-dropdown').addClass('rock-active')
        }

        callback && callback()
      }

      transition ? $active.one($.support.transition.end, next) :  next()

      $active.removeClass('rock-in')
    }
  }


 /* TAB PLUGIN DEFINITION
  * ===================== */

  $.fn.tab = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tab')
      if (!data) $this.data('tab', (data = new Tab(this)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tab.Constructor = Tab


 /* TAB DATA-API
  * ============ */

  $(function () {
    $('body').on('click.tab.data-api', '[data-toggle="rock-tab"], [data-toggle="rock-pill"]', function (e) {
      e.preventDefault()
      $(this).tab('show');
    })
  })

}( window.jQuery )
