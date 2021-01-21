// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("scripts")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
Notification.requestPermission().then((result) => {})
import "controllers"
import "@fortawesome/fontawesome-free/css/all.css"


import 'stylesheet'
import 'styles'

require("flatpickr")
import("flatpickr/dist/flatpickr.min.css")

import "tempusdominus-bootstrap-4"
import "tempusdominus-bootstrap-4/build/css/tempusdominus-bootstrap-4.min.css"
import "font-awesome/css/font-awesome.min.css"
import $ from "jquery"
window.$ = $

import 'swiper/swiper-bundle.css';
// window.Swiper = require('Swiper');

window.Swiper = Swiper
