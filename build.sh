#!/bin/bash

gem uninstall teamwork; rake install_extra_deps;rake repackage; rake install_gem; gem install --local pkg/te*.gem; ruby ../test_t*

