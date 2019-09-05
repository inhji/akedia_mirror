import "phoenix_html"
//import Vue from 'vue'
import tags from 'bulma-tagsinput'
import * as Credential from "./webauthn/credential"
import * as Encoder from "./webauthn/encoder"

const webauthnUrl = "/api/webauthn"

// const app = new Vue({
//   el: "form.vue",
//   data: {
//     charCount: 0,
//     maxChars: 400,
//     zenActive: false
//   },
//   mounted() {
//     tags.attach()
//   },
//   methods: {
//     updateCharCount(e) {
//       const charCount = e.target.value.length
//       this.charCount = charCount
//     },
//     closeZen() {
//       this.zenActive = false
//     }
//   }
// })

function callback(data) {
    var credentialOptions = data;
    credentialOptions["challenge"] = Encoder.strToBin(credentialOptions["challenge"]);
    // Registration
    if (credentialOptions["user"]) {
      credentialOptions["user"]["id"] = Encoder.strToBin(credentialOptions["user"]["id"]);
      var credential_name = document.getElementById("registration-create").querySelector("input[name='credential_name']").value;
      var name = document.getElementById("registration-create").querySelector("input[name='name']").value;
      var callback_url = `${webauthnUrl}/callback?credential_name=${credential_name}&name=${name}`;
      
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


