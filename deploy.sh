#!/bin/bash
git clone https://github.com/stv2509/infra.git
cd infra && bundle install
puma -d
