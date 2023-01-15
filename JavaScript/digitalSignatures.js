const secp = require("ethereum-cryptography/secp256k1");
const { keccak256 } = require("ethereum-cryptography/keccak");
const { utf8ToBytes } = require("ethereum-cryptography/utils");
const { toHex } = require("ethereum-cryptography/utils");

// generate random private key
const privateKey = toHex(secp.utils.randomPrivateKey());
console.log("Private key:", privateKey);

// generate public key from prev random private key
console.log("Public key:", getAddress(privateKey));

function hashMessage(msg){
    return keccak256(utf8ToBytes(msg)); // turns the message into an array of bytes to then hash the message using keccak256
                                        // check https://github.com/ethereum/js-ethereum-cryptography#hashes-sha256-keccak-256-ripemd160-blake2b
}

function getAddress(privateKey) {
    return toHex(keccak256(secp.getPublicKey(privateKey).slice(1)).slice(-20)); // an Ethereum address is the last 20 bytes of the hash of the public key
                                                                                // the first byte specifies the format of the key
                                                                                // check https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray/slice
}

async function signMessage(msg, PRIVATE_KEY) {
    return secp.sign((hashMessage(msg)), PRIVATE_KEY, { recovered: true }); // note: { recovered: true } is needed to then recover the public key from the signature
                                                                            // check https://github.com/ethereum/js-ethereum-cryptography#hashes-sha256-keccak-256-ripemd160-blake2b
                                                                            // check https://github.com/paulmillr/noble-secp256k1#signmsghash-privatekey                                               
}

async function recoverAddress(msg, signature, recoveryBit) {
    return toHex(keccak256(secp.recoverPublicKey(hashMessage(msg), signature, recoveryBit).slice(1)).slice(-20)); //check https://github.com/paulmillr/noble-secp256k1#recoverpublickeyhash-signature-recovery
}

async function signedMessage() {

    let message = 'send funds';

    // sign message
    let [sig, recoveryBit] = await signMessage(message, privateKey);
    console.log("\n" + "Message:", message + "\n" + "Signed message:", toHex(keccak256(sig)) +  "\n" + "recoveryBit:", recoveryBit + "\n");

    // recover publicKey from signed message
    let recovered = recoverAddress((message), sig, recoveryBit);
    console.log("Recovered public key:", (await recovered).toString());

}

signedMessage();