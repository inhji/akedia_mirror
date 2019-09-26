import * as Credential from "./credential"
import * as Encoder from "./encoder"

document.addEventListener("DOMContentLoaded", function () {
  const form = document.querySelector("#session-create")

  if (!form) {
    return
  }

  fetch("/auth/webauthn", {method: "POST", body: new FormData(form) })
    .then((response) => {
      return response.json();
    }).then((data) => {
      console.log(data)
      var credentialOptions = data;
      credentialOptions["challenge"] = Encoder.strToBin(credentialOptions["challenge"]);
      credentialOptions["allowCredentials"].forEach(function(cred, i){
        cred["id"] = Encoder.strToBin(cred["id"]);
      })
      Credential.get(credentialOptions);
    }).catch((e) => {
      console.log(e);
    });
});