// app/assets/javascripts/application.js

//= require turbolinks

//= require materialize
//= require rails-ujs
//= require_tree .
//= require materialize_init
//= require navbar
//= require analyst_dashboard.js
//= require home.js

document.addEventListener('DOMContentLoaded', function () {
	var hiddenImage = document.getElementById('hiddenImage');
	hiddenImage.style.display = 'none';
	var elems = document.querySelectorAll('.sidenav');
	var instances = M.Sidenav.init(elems);
});

document.addEventListener('turbolinks:load', function () {
	var elems = document.querySelectorAll('.sidenav');
	var instances = M.Sidenav.init(elems);
});

document.addEventListener('visibilitychange', function () {
	var elems = document.querySelectorAll('.sidenav');
	var instances = M.Sidenav.init(elems);
});

document.getElementById('search-form').addEventListener('submit', function (event) {
	var minPriceField = document.getElementById('min_price');
	var maxPriceField = document.getElementById('max_price');
	var minPrice = parseFloat(minPriceField.value);
	var maxPrice = parseFloat(maxPriceField.value);

	if (!isNaN(minPrice) && !isNaN(maxPrice) && minPrice > maxPrice) {
		minPriceField.value = maxPrice;
		maxPriceField.value = minPrice;
	}
});

document.getElementById('copyC').addEventListener('click', function () {
	var hiddenImage = document.getElementById('hiddenImage');
	if (hiddenImage.style.display === 'none') {
		hiddenImage.style.display = 'block';
	} else {
		hiddenImage.style.display = 'none';
	}
});