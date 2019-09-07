import * as Credential from "./webauthn/credential"
import * as Encoder from "./webauthn/encoder"

const webauthnUrl = "/api/webauthn"
const loginUrl = "/auth/webauthn"

function callback(data) {
  var credentialOptions = data;
  credentialOptions["challenge"] = Encoder.strToBin(credentialOptions["challenge"]);
  // Registration
  if (credentialOptions["user"]) {
    credentialOptions["user"]["id"] = Encoder.strToBin(credentialOptions["user"]["id"]);
    var device_name = document.getElementById("registration-create").querySelector("input[name='device_name']").value;
    var callback_url = `${webauthnUrl}/callback?device_name=${device_name}&name=${name}`;
    
    Credential.create(encodeURI(callback_url), credentialOptions);
  }
}

[document.getElementById("registration-create")].filter(item => item).forEach((registrationForm) => {
  registrationForm.addEventListener("submit", (e) => {
    e.preventDefault();
    let data = new FormData(e.target);
    const url = webauthnUrl;
    fetch(url, {
        method: "POST",
        body: data
    })
    .then((response) => {
      console.log(response);
       return response.json();
    }).then((data) => {
      callback(data)
    }).catch((e) => {
      console.error(e);
    });
  });
});

document.addEventListener("DOMContentLoaded", function () {
  const form = document.querySelector("#session-create")

  if (!form) {
    return
  }

  fetch(loginUrl, {method: "POST", body: new FormData(form) })
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