function showAddButton(id_product) {
    if (document.getElementById("inputLabel-"+id_product).value!="")
        document.getElementById("submitLabel-"+id_product).style.display="inline";
    else
        document.getElementById("submitLabel-"+id_product).style.display="none";
}

  document.getElementById('search-form').addEventListener('submit', function(event) {

    var minPriceField = document.getElementById('min_price');
    var maxPriceField = document.getElementById('max_price');
    var minPrice = parseFloat(minPriceField.value);
    var maxPrice = parseFloat(maxPriceField.value);

    if (!isNaN(minPrice) && !isNaN(maxPrice) && minPrice > maxPrice) {
      // Swap the values
      minPriceField.value = maxPrice;
      maxPriceField.value = minPrice;
    }
  });