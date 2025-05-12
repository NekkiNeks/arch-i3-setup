#!/bin/bash

# Функция для получения layout активного окна
get_layout() {
  i3-msg -t get_tree | jq -r '
    def find_focused:
      recurse(.nodes[], .floating_nodes[]) | select(.focused);

    def find_parent_with_layout($focused):
      recurse(.nodes[], .floating_nodes[])
      | select((.nodes + .floating_nodes | index($focused))? != null)
      | select(.layout != "none")
      | .layout;

    . as $tree
    | find_focused as $focused
    | find_parent_with_layout($focused)
    | select(length > 0)
  '
}

layout=$(get_layout)

case "$layout" in
  stacked)
    i3-msg layout splith 
    ;;
  splith|splitv)
    i3-msg layout stacking 
    ;;
esac