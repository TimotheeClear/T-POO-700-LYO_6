#!/usr/bin/env bash
source .env
export MIX_ENV="dev"
mix phx.server
