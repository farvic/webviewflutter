// function test() {
//     // document.getElementById("mid").innerHTML = "HOY";
//     console.log(3010);
//     return 2;
// }

function test() {
    // document.getElementById("mid").innerHTML = "HOY";
    console.log("FUNCIONOU CACETEEEEE");
    return 2;
}

function loadDoc() {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        console.log(this.responseText);
      }
    };

    xhttp.open("GET", "https://elesson.com.br/api/offline/cobject/3178", true);
    xhttp.send();
  }