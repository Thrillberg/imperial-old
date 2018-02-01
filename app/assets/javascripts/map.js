$(document).on('turbolinks:load', function() {
  var allFactories = document.getElementsByClassName("factory");
  for (let factory of allFactories) {
    checkForBuiltFactory(factory)
  }

  var allPieces = document.getElementsByClassName("piece");
  for (let piece of allPieces) {
    checkForPiece(piece);
    getManeuverableRegions(piece);
  }

  var allFlags = document.getElementsByClassName("flag");
  for (let flag of allFlags) {
    setFlags(flag);
  }

  Array.from(allFactories).map(getHomeRegions);

  function getHomeRegions(factory) {
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
      });
    }
  }

  function getManeuverableRegions(piece) {
    if (window.regions) {
      window.regions.forEach(function(region) {
        if (piece.id === region + "-army" || piece.id === region + "-fleet") {
          var svgRegion = document.getElementById(region);
          svgRegion.classList.add("glow-on-hover");
          switch (window.turn) {
            case 'maneuver':
              svgRegion.addEventListener("click", () => { movePieceFrom(svgRegion) });
              break;
            case 'maneuver-destination':
              svgRegion.addEventListener("click", () => { movePieceTo(svgRegion) });
            default:
              break;
          }
        }
      });
    }
  }

  function setFlags(flag) {
    window.flags.forEach(function(actualFlag) {
      if (flag.id == actualFlag.region_name + "-flag") {
        flag.classList.add("show");
        flag.style.fill = actualFlag.color;
      }
    });
  }

  function buildFactory(region) {
    $.ajax({
      url: '/games/' + window.game + '/investors/' + window.investorId + '/build_factory?region=' + region.id,
      method: 'POST'
    });
  }

  function importPiece(region, importCount) {
    $.ajax({
      url: '/games/' + window.game + '/investors/' + window.investorId + '/import?region=' + region.id,
      method: 'POST',
      data: {
        import_count: parseInt(importCount) + 1
      }
    });
  }

  function movePieceFrom(region) {
    $.ajax({
      url: '/games/' + window.game + '/maneuver?origin_region=' + region.id,
      method: 'POST'
    });
  }

  function movePieceTo(destination) {
    $.ajax({
      url: '/games/' + window.game + '/maneuver_destination?destination_region=' + destination.id,
      method: 'POST',
      data: {
        origin_region: originRegion
      }
    });
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
      if (piece.id == `${existingPiece.region_name}-${existingPiece.type}`) {
        if (existingPiece.type == "fleet") {
          var shape = piece.getElementsByTagName("ellipse")[0];
        } else {
          var shape = piece.getElementsByTagName("rect")[0];
        };

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
