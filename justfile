force := "false"


default:
  @just --list

install-bluebuild-cli force=force:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p .local/{bin,src}
    git clone https://github.com/blue-build/cli.git .local/src/bluebuild-cli || true
    # Check if the binary is already installed and force is false.
    if [ -f .local/bin/bluebuild ] && [ "{{force}}" = "false" ]; then
        echo "bluebuild already installed. Use force=true to reinstall."
        exit 0
    fi
    (cd .local/src/bluebuild-cli &&
        git fetch &&
        git reset --hard main &&
        docker run --rm \
            -v "$(pwd):/mnt" \
            -w /mnt \
            rust:latest \
            cargo install --locked blue-build --root . \
            )
    cp .local/src/bluebuild-cli/bin/bluebuild .local/bin
    chmod +x .local/bin/bluebuild

activate:
    #!/usr/bin/env bash
    set -euo pipefail
    LOCALBIN="$(pwd)/.local/bin"
    echo "export PATH=\"\${PATH}:${LOCALBIN}\""
    echo "# Per usare: eval \$(just path-command)"
