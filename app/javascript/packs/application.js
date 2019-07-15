/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "core-js/stable";
import "regenerator-runtime/runtime";
import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';
import 'select2';
import $ from 'jquery';
window.jQuery = $;
window.$ = $;

const application = Application.start();
const context = require.context('controllers', true, /.js$/);
application.load(definitionsFromContext(context));

import GoogleAnalytics from './google_analytics';
new GoogleAnalytics.load();

require('materialize-css');

document.addEventListener('turbolinks:load', function() {
  $('.dropdown-trigger').dropdown({
    alignment: 'right',
    constrainWidth: false,
    coverTrigger: false
  });
  $('#ride_day').datepicker();
  $('#ride_time').timepicker();

  M.updateTextFields(); // reinitialize form label
  Waves.displayEffect(); // reinitialize wave effect on button
});

if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/service-worker.js', { scope: './' }).then(function(reg) {
    console.log('[Companion]', 'Service worker registered!');
    console.log(reg);
  });
}
