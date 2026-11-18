// L'icône du menu DSM ouvre cette page, servie par DSM (même nom d'hôte, même HTTPS que DSM). Elle mène à Merathon :
// - à l'adresse indiquée à l'installation (MERATHON_PUBLIC_URL, par exemple celle du proxy inverse), si elle existe ;
// - sinon au port du service sur ce NAS, en HTTP : impossible depuis un DSM en HTTPS dont le domaine impose HTTPS (HSTS, comme
//   myds.me), d'où l'explication affichée au lieu d'une erreur de connexion.
(function () {
  var french = (navigator.language || "").toLowerCase().indexOf("fr") === 0;
  var text = function (fr, en) { return french ? fr : en; };
  var message = document.getElementById("message");
  var link = document.getElementById("link");
  var help = document.getElementById("help");
  var show = function (url) { link.href = url; link.textContent = url; link.hidden = false; };

  var configured = window.MERATHON_URL || "";
  if (/^https?:\/\//.test(configured)) {
    message.textContent = text("Ouverture de Merathon…", "Opening Merathon…");
    show(configured);
    window.location.replace(configured);
    return;
  }

  var direct = "http://" + window.location.hostname + ":" + (window.MERATHON_PORT || "8765") + "/";
  show(direct);
  if (window.location.protocol !== "https:") {
    message.textContent = text("Ouverture de Merathon…", "Opening Merathon…");
    window.location.replace(direct);
    return;
  }
  message.textContent = text(
    "Merathon écoute en HTTP sur ce port, et DSM est ouvert en HTTPS : ce lien peut être refusé par votre navigateur.",
    "Merathon listens over HTTP on this port, and DSM is open over HTTPS: your browser may refuse this link."
  );
  help.textContent = text(
    "Pour que cette icône ouvre Merathon : créez une règle de proxy inverse HTTPS dans DSM (Portail de connexion > Avancé > Proxy inverse, avec l'en-tête WebSocket), puis indiquez son adresse dans MERATHON_PUBLIC_URL (/var/packages/Merathon/var/config.env) et redémarrez le paquet.",
    "To make this icon open Merathon: create an HTTPS reverse proxy rule in DSM (Login Portal > Advanced > Reverse Proxy, with the WebSocket header), then put its address in MERATHON_PUBLIC_URL (/var/packages/Merathon/var/config.env) and restart the package."
  );
})();
