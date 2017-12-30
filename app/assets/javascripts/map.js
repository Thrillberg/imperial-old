$(document).ready(function() {
  var allFactories = document.getElementsByClassName("factory");
  for (let factory of allFactories) {
    checkForBuiltFactory(factory)
  }

  function checkForBuiltFactory(factory) {
    window.factories.forEach(function(builtFactory) {
      if (factory.id === builtFactory) {
        factory.classList.add("show");
      };
    });
  }
})
