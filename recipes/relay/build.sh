#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cd compiler

# Disable unexpected_cfg warning
echo "[lints.rust]" >> crates/intern/Cargo.toml
echo "unexpected_cfgs = { level = 'warn', check-cfg = ['cfg(memory_consistency_assertions)'] }" >> crates/intern/Cargo.toml

cargo-bundle-licenses \
    --format yaml \
    --output ${SRC_DIR}/THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path crates/relay-bin

# strip debug symbols
"$STRIP" "$PREFIX/bin/$PKG_NAME"
