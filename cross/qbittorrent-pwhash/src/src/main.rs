use base64::{Engine, engine::general_purpose::STANDARD};
use pbkdf2::pbkdf2_hmac;
use sha2::Sha512;

fn main() {
    let password = match std::env::args().nth(1) {
        Some(p) => p,
        None => {
            eprintln!("Usage: qbt-pwhash <password>");
            std::process::exit(1);
        }
    };

    let mut salt = [0u8; 16];
    getrandom::getrandom(&mut salt).unwrap();

    let mut hash = [0u8; 64];
    pbkdf2_hmac::<Sha512>(password.as_bytes(), &salt, 100000, &mut hash);

    println!("@ByteArray({}:{})", STANDARD.encode(&salt), STANDARD.encode(&hash));
}
