typeset -gA _warp_edit_select=(
  '^[[1;2D' backward-char
  '^[[1;2C' forward-char
  '^[[1;2A' beginning-of-line
  '^[[1;2B' end-of-line
  '^[[1;2H' beginning-of-line
  '^[[1;2F' end-of-line
  '^[[1;4D' backward-word
  '^[[1;4C' emacs-forward-word
  '^[[1;6D' backward-word
  '^[[1;6C' emacs-forward-word
)

typeset -gA _warp_edit_move=(
  '^[[1;3D' backward-word
  '^[[1;3C' emacs-forward-word
  '^[[1;5D' backward-word
  '^[[1;5C' emacs-forward-word
  '^U' backward-kill-line
  '^[[122;10u' redo
)

_warp_edit_select() {
  if (( !REGION_ACTIVE )); then
    MARK=$CURSOR REGION_ACTIVE=1
    zle -K warp-select
  fi
  zle ${WIDGET#warp-edit-select-}
}

_warp_edit_select_all() {
  MARK=0 CURSOR=$#BUFFER REGION_ACTIVE=1
  zle -K warp-select
}

_warp_edit_exit() {
  REGION_ACTIVE=0
  zle -K main
}

_warp_edit_delete() {
  local a=$(( MARK < CURSOR ? MARK : CURSOR )) b=$(( MARK > CURSOR ? MARK : CURSOR ))
  BUFFER=$BUFFER[1,a]$BUFFER[b+1,-1]
  CURSOR=$a
  _warp_edit_exit
}

_warp_edit_replace() {
  _warp_edit_delete
  zle -U -- "$KEYS"
}

_warp_edit_deselect() {
  _warp_edit_exit
  zle -U -- "$KEYS"
}

_warp_edit_collapse() {
  if [[ $WIDGET == *left ]]; then
    (( CURSOR = MARK < CURSOR ? MARK : CURSOR ))
  else
    (( CURSOR = MARK > CURSOR ? MARK : CURSOR ))
  fi
  _warp_edit_exit
}

_warp_edit_paste() {
  _warp_edit_delete
  zle bracketed-paste
}

() {
  local key widget
  zle -N warp-edit-select-all _warp_edit_select_all
  zle -N warp-edit-delete _warp_edit_delete
  zle -N warp-edit-replace _warp_edit_replace
  zle -N warp-edit-deselect _warp_edit_deselect
  zle -N warp-edit-collapse-left _warp_edit_collapse
  zle -N warp-edit-collapse-right _warp_edit_collapse
  zle -N warp-edit-paste _warp_edit_paste

  bindkey -N warp-select
  bindkey -M warp-select -R '^@'-'^?' warp-edit-deselect
  bindkey -M warp-select -R ' '-'~' warp-edit-replace
  bindkey -M warp-select -R '\M-^@'-'\M-^?' warp-edit-replace
  for key in '^?' '^H' '^[[3~'; do bindkey -M warp-select $key warp-edit-delete; done
  for key in '^[[D' '^[OD'; do bindkey -M warp-select $key warp-edit-collapse-left; done
  for key in '^[[C' '^[OC'; do bindkey -M warp-select $key warp-edit-collapse-right; done
  bindkey -M warp-select '^[[200~' warp-edit-paste

  for key widget in ${(kv)_warp_edit_select}; do
    zle -N warp-edit-select-$widget _warp_edit_select
    bindkey -M main $key warp-edit-select-$widget
    bindkey -M warp-select $key warp-edit-select-$widget
  done
  for key widget in ${(kv)_warp_edit_move}; do bindkey -M main $key $widget; done
  for key in main warp-select; do bindkey -M $key '^[[97;9u' warp-edit-select-all; done
}
