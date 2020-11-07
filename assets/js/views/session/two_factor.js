import MainView from '../main';
import * as Credential from "../../webauthn/credential"
import * as Encoder from "../../webauthn/encoder"

export default class View extends MainView {
  mount() {
    super.mount();

    const form = document.querySelector("#session-create")

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
  }

  unmount() {
    super.unmount();
  }
}
