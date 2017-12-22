$(document).ready(function() {
  function greeting(city) {
    console.log(city)
  }
  
  function clickable(city) {
    document.getElementById(city).addEventListener('click', () => greeting(city));
  }

  ['Munich', 'Berlin', 'Hamburg', 'Danzig', 'Cologne', 'Vienna', 'Budapest', 'Trieste', 'Lemberg', 'Prague'].forEach(clickable)
})
