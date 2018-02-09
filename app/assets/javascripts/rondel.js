$(document).ready(function() {
  if (window.steps && window.countrySteps) {
    window.steps.forEach(addListener)
    window.countrySteps.forEach(placeMeeple)
  }

  function addListener(step) {
    var svgRegion = document.getElementById(step.id);
    svgRegion.addEventListener("click", takeTurn);
    svgRegion.classList.add("glow-on-hover");
    if (step.cost == 3) {
      svgRegion.classList.add("three");
    } else if (step.cost == 2) {
      svgRegion.classList.add("two");
    } else if (step.cost == 1) {
      svgRegion.classList.add("one");
    }
  }

  function placeMeeple(countryStep) {
    if (countryStep.step) {
      var meeple = document.getElementById(countryStep.step + '-' + countryStep.name);
      meeple.classList.add("show");
      meeple.style.fill = countryStep.color;
    }
  }

  function takeTurn(evt) {
    window.steps.forEach((step) => {
      document.getElementById(step.id).removeEventListener("click", takeTurn);
    });
    $.ajax({
      url: '/games/' + window.game + '/investors/' + window.investorId + '/turn/',
      method: 'POST',
      data: {
        step: evt.target.id
      }
    });
  }
});
