/*!
 * Navigation State
 */

$(function() {
  'use strict';

  var path = location.pathname.substring(1),
      $selector;

  if (path) {
    $selector = $('.navbar .nav a[href$="' + path + '"]');
  } else {
    $selector = $('.navbar .nav a[href$="/"]');
  }

  $selector.parent().attr('class', 'active');

});
