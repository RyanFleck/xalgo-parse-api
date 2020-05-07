var repl;
var result;

document.addEventListener("DOMContentLoaded", function () {
  console.log("Loaded regular javascript file.");

  function max(a, b) {
    if (a > b) {
      return a;
    }
    return b;
  }

  repl = document.getElementById("rule-or-table");
  result = document.getElementById("result");
  repl.setAttribute("spellcheck", "false");

  // Parse rule button.
  document.getElementById("parse-rule").onclick = function () {
    var myHeaders = new Headers();
    myHeaders.append("Content-Type", "text/plain");

    var raw = document.getElementById("rule-or-table").value;

    var requestOptions = {
      method: "POST",
      headers: myHeaders,
      body: raw,
      redirect: "follow",
    };

    fetch("/api/v5/parse/rule", requestOptions)
      .then((response) => response.text())
      .then((result) => display(result))
      .catch((error) => display_error(error));
  };

  // Parse table button
  document.getElementById("parse-table").onclick = function () {
    var myHeaders = new Headers();
    myHeaders.append("Content-Type", "text/plain");

    var raw = document.getElementById("rule-or-table").value;

    var requestOptions = {
      method: "POST",
      headers: myHeaders,
      body: raw,
      redirect: "follow",
    };

    fetch("/api/v5/parse/table", requestOptions)
      .then((response) => response.text())
      .then((result) => display(result))
      .catch((error) => display_error(error));
  };

  // Load rule
  document.getElementById("load-example").onclick = function () {
    if (window.XMLHttpRequest) {
      xmlhttp = new XMLHttpRequest();
      xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
          repl.value = xmlhttp.responseText;
          resize_repl();
        }
      };
      xmlhttp.open("GET", "/test.rule", false);
      xmlhttp.send();
    } else {
      repl.value = "Your browser doesn't support XMLHttpRequest.";
    }
  };

  repl.onkeydown = function (e) {
    resize_repl();
  };

  repl.onpaste = function (e) {
    var resize = window.setInterval(function () {
      resize_repl();
      clean_repl();
      clearInterval(resize);
    }, 10);
  };

  function display(res) {
    pretty = JSON.stringify(JSON.parse(res), null, 2);
    result.innerHTML = pretty;
  }

  function display_error(err) {
    result.innerHTML = "An error was encountered while parsing.";
  }

  function resize_repl() {
    // Resize
    repl.style.height = "auto";
    repl.style.height = max(300, repl.scrollHeight + 40) + "px";
  }

  function clean_repl() {
    repl.value = repl.value.replace("(opens in new tab)", "");
  }
});
