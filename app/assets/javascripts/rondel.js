$(document).on('turbolinks:load', function() {
  window.steps.forEach(addListener)

  function addListener(step) {
    var svgRegion = document.getElementById(step.id);
    svgRegion.addEventListener("click", () => { takeTurn(step) });
    svgRegion.classList.add("glow-on-hover");
    if (step.cost == 3) {
      svgRegion.classList.add("three");
    } else if (step.cost == 2) {
      svgRegion.classList.add("two");
    } else if (step.cost == 1) {
      svgRegion.classList.add("one");
    }
  }

  function takeTurn(step) {
    $.ajax({
      url: '/games/' + window.game + '/investors/' + window.investorId + '/turn/',
      method: 'POST',
      data: {
        step: step.id
      }
    });
  }
});
