#!/bin/bash

gem uninstall teamwork; rake repackage; rake install_gem; gem install --local ./pkg/te*.gem

