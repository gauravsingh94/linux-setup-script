#!/bin/bash

# Set Git aliases
git config --global alias.gc commit
git config --global alias.gs status
git config --global alias.ga add
git config --global alias.gps push
git config --global alias.gpl pull
git config --global alias.gr reset

echo "Git aliases are configured:"
echo "gc -> commit"
echo "gst -> status"
echo "ga -> add"
echo "gps -> push"
echo "gpl -> pull"
echo "gr -> reset"
