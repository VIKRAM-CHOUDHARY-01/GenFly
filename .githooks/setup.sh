#!/bin/sh
# Run once after cloning: sh .githooks/setup.sh
git config core.hooksPath .githooks
chmod +x .githooks/commit-msg
chmod +x .githooks/pre-push
echo "Git hooks configured. Branch and commit conventions are now enforced."
