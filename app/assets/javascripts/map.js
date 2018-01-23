$(document).on('turbolinks:load', function() {
  var allFactories = document.getElementsByClassName("factory");
  for (let factory of allFactories) {
    checkForBuiltFactory(factory)
  }

  var allPieces = document.getElementsByClassName("piece");
  for (let piece of allPieces) {
    checkForPiece(piece)
  }

  Array.from(allFactories).map(getCurrentRegions);

  function getCurrentRegions(factory) {
    if (window.regions) {
      window.regions.forEach(function(region) {
        if (factory.id === region.toLowerCase() + "-factory") {
          var svgRegion = document.getElementById(region);
          svgRegion.classList.add("glow-on-hover");
          switch (window.turn) {
            case 'build_factory':
              svgRegion.addEventListener("click", () => { buildFactory(svgRegion) });
              break;
            case 'import':
              svgRegion.addEventListener("click", () => { importPiece(svgRegion, window.importCount) });
              break;
            default:
              break;
          }
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

  function importPiece(region, importCount) {
    $.ajax({
      url: '/games/' + window.game + '/import?region=' + region.id,
      method: 'POST',
      data: {
        import_count: parseInt(importCount) + 1
      }
    })
  }

  function checkForBuiltFactory(factory) {
    window.factories.forEach(function(builtFactory) {
      if (factory.id === builtFactory) {
        factory.classList.add("show");
      };
    });
  }

  function checkForPiece(piece) {
    window.pieces.forEach(function(existingPiece) {
      if (piece.id.startsWith(existingPiece.region_name)) {
        var shape = piece.getElementsByTagName("rect")[0] || piece.getElementsByTagName("ellipse")[0];
        shape.style.fill = existingPiece.color;
        shape.style.stroke = existingPiece.font_color;
        shape.style.strokeWidth = '25px';

        var number = piece.getElementsByTagName("tspan")[0];
        number.style.fill = existingPiece.font_color;

        var count = parseInt(number.textContent);
        count += 1;
        number.textContent = count;
        piece.classList.add("show");
      }
    });
  }
})
