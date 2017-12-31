$(document).on('turbolinks:load', function() {
  var allFactories = document.getElementsByClassName("factory");
  for (let factory of allFactories) {
    checkForBuiltFactory(factory)
  }

  Array.from(allFactories).map(getCurrentRegions);

  function getCurrentRegions(factory) {
    if (window.regions) {
      window.regions.forEach(function(region) {
        if (factory.id === region.toLowerCase() + "-factory") {
          var svgRegion = document.getElementById(region);
          svgRegion.classList.add("glow-on-hover");
          svgRegion.addEventListener("click", () => { buildFactory(svgRegion) })
        }
      })
    }
  }

  function buildFactory(region) {
    $.ajax({
      url: '/games/' + window.game + '/build_factory?region=' + region.id,
      method: 'POST'
    })
  }

  function checkForBuiltFactory(factory) {
    window.factories.forEach(function(builtFactory) {
      if (factory.id === builtFactory) {
        factory.classList.add("show");
      };
    });
  }
})
