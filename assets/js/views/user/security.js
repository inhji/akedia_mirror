import * as Credential from "../../webauthn/credential"
import * as Encoder from "../../webauthn/encoder"

const webauthnUrl = "/api/webauthn"

export default class View extends MainView {
  mount() {
    super.mount();

    function callback(data) {
      var credentialOptions = data;
      credentialOptions["challenge"] = Encoder.strToBin(credentialOptions["challenge"]);
      // Registration
      if (credentialOptions["user"]) {
        credentialOptions["user"]["id"] = Encoder.strToBin(credentialOptions["user"]["id"]);
        var device_name = document.getElementById("registration-create").querySelector("input[name='device_name']").value;
        var callback_url = `${webauthnUrl}/callback?device_name=${device_name}&name=${name}`;
        
        console.log("Creating credentials:")
        console.log(credentialOptions)
        Credential.create(encodeURI(callback_url), credentialOptions);
      }
    }

    [document.getElementById("registration-create")].filter(item => item).forEach((registrationForm) => {
      console.log("Creating submit handler")
      registrationForm.addEventListener("submit", (e) => {
        e.preventDefault();
        let data = new FormData(e.target);
        const url = webauthnUrl;

        console.log("Calling api to get challenge")
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
  }

  unmount() {
    super.unmount()
  }
}



