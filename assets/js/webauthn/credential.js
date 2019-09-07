// Credits: https://github.com/cedarcode/webauthn-rails-demo-app
import * as Encoder from "./encoder";

function callback(url, body, redirect_url) {
  fetch(url, {
    method: "POST",
    body: JSON.stringify(body),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json"
    },
    credentials: 'same-origin'
  }).then(function() {
    window.location.replace(redirect_url)
  });
}

function create(callbackUrl, credentialOptions) {
  navigator.credentials.create({ "publicKey": credentialOptions })
  .then(function(attestation) {
    callback(callbackUrl, {
      id: attestation.id,
      response: {
        clientDataJSON: Encoder.binToStr(attestation.response.clientDataJSON),
        attestationObject: Encoder.binToStr(attestation.response.attestationObject)
      }
    }, "/admin/webauthn");
  }).catch(function(error) {
    console.log(error);
  });

  console.log("Creating new public key credential...");
}

function get(credentialOptions) {
  navigator.credentials.get({ "publicKey": credentialOptions }).then(function(credential) {
    var assertionResponse = credential.response;

    callback("/api/webauthn/session_callback", {
      id: Encoder.binToStr(credential.rawId),
      response: {
        clientDataJSON: Encoder.binToStr(assertionResponse.clientDataJSON),
        signature: Encoder.binToStr(assertionResponse.signature),
        userHandle: Encoder.binToStr(assertionResponse.userHandle),
        authenticatorData: Encoder.binToStr(assertionResponse.authenticatorData)
      }
    }, "/");
  }).catch(function(error) {
    console.log(error);
  });

  console.log("Getting public key credential...");
}

export { create, get }
