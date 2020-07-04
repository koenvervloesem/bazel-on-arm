#!/bin/bash
# Check code of this project

# Shell scripts

bashate scripts/*.sh
shellcheck scripts/*.sh

# GitHub Actions files
yamllint .github/workflows/
