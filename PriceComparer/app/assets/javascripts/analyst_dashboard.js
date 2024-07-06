document.addEventListener('DOMContentLoaded', function () {
	M.AutoInit();
});

function addPriceRange() {
	var index = document.querySelectorAll('.price-range').length;
	var priceRanges = document.getElementById('price-ranges');
	var newRange = document.createElement('tr');
	newRange.classList.add('price-range');
	newRange.innerHTML = `
	  <td><input type="number" name="price_ranges[${index}][min]" class="validate" /></td>
	  <td><input type="number" name="price_ranges[${index}][max]" class="validate" /></td>
	  <td></td>
	  <td><button type="button" class="btn red" onclick="removePriceRange(this)"><i class="material-icons">remove</i></button></td>
	`;
	priceRanges.appendChild(newRange);
}

function removePriceRange(button) {
	button.parentElement.parentElement.remove();
}

function savePriceRanges() {
	var ranges = [];
	document.querySelectorAll('.price-range').forEach(function (row) {
		var min = parseFloat(row.querySelector('input[name*="[min]"]').value);
		var max = parseFloat(row.querySelector('input[name*="[max]"]').value);
		ranges.push({ min: min, max: max });
	});
	localStorage.setItem('priceRanges', JSON.stringify(ranges));
	loadPriceRanges();
}

function loadPriceRanges() {
	var storedRanges = JSON.parse(localStorage.getItem('priceRanges'));
	if (storedRanges) {
		var urlParams = new URLSearchParams();
		storedRanges.forEach(function (range, index) {
			urlParams.append(`price_ranges[${index}][min]`, range.min);
			urlParams.append(`price_ranges[${index}][max]`, range.max);
		});
		urlParams.append('commit', 'Sincronizza cambiamenti');
		var currentURL = `${window.location.protocol}//${window.location.host}`;
		var url = `${currentURL}/products_dashboard?${urlParams.toString()}`;
		window.location.href = url;
	}
}

var storedRanges = JSON.parse(localStorage.getItem('priceRanges'));
document.getElementById('price-ranges').addEventListener('change', savePriceRanges);