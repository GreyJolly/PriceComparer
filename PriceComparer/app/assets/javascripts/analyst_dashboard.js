document.addEventListener('DOMContentLoaded', function () {
	M.AutoInit();
	selectCategory();
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
	document.getElementById('save-changes').style.display = "inline";
}

function removePriceRange(button) {
	button.parentElement.parentElement.remove();
	document.getElementById('save-changes').style.display = "inline";
}

function savePriceRanges() {
	var ranges = [];
	document.querySelectorAll('.price-range').forEach(function (row) {
		var min = parseFloat(row.querySelector('input[name*="[min]"]').value);
		var max = parseFloat(row.querySelector('input[name*="[max]"]').value);
		if (isNaN(min) || min < 0) min = 0;
		if (isNaN(max) || max < 0) max = 0;
		if (min < max)
			ranges.push({ min: min, max: max });
		else
			ranges.push({ min: max, max: min });
	});

	var selectedCategory = document.getElementById('category-select').value;
	var dataToStore = {
		category: selectedCategory,
		ranges: ranges
	};

	localStorage.setItem('priceRanges', JSON.stringify(dataToStore));
}

function loadPriceRanges() {
	var storedData = JSON.parse(localStorage.getItem('priceRanges'));
	if (storedData && storedData.ranges) {
		var urlParams = new URLSearchParams();
		storedData.ranges.forEach(function (range, index) {
			urlParams.append(`price_ranges[${index}][min]`, range.min);
			urlParams.append(`price_ranges[${index}][max]`, range.max);
		});

		if (storedData.category) {
			urlParams.append('category', storedData.category);
		}

		urlParams.append('commit', 'Sincronizza cambiamenti');
		var currentURL = `${window.location.protocol}//${window.location.host}`;
		var url = `${currentURL}/products_dashboard?${urlParams.toString()}`;
		window.location.href = url;
	}
}

function saveAndLoadPriceRanges() {
	savePriceRanges();
	loadPriceRanges();
}

function selectCategory() {
	var storedData = JSON.parse(localStorage.getItem('priceRanges'));
	var categorySelect = document.getElementById('category-select');

	if (storedData && storedData.category) {
		var selectedCategory = storedData.category;

		// Loop through options and set the selected one
		for (var i = 0; i < categorySelect.options.length; i++) {
			if (categorySelect.options[i].value === selectedCategory) {
				categorySelect.selectedIndex = i;
				break;
			}
		}
	}
}

function updatePriceRange() {
	document.getElementById('save-changes').style.display = "inline";
	savePriceRanges();
}
var storedRanges = JSON.parse(localStorage.getItem('priceRanges'));