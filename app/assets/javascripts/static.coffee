# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
(($) ->
  $ ->
    $('.button-collapse').sideNav()
    return
  return
) jQuery

$ ->
  $('.datepicker').pickadate
    selectMonths: true
    selectYears: 5
    closeOnSelect: true
    formatSubmit: 'dd/mm/yyyy'
    format: 'dd/mm/yyyy'
