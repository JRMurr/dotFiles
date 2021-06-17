function startDev
    set --local tab_title "Bodata"
    set --local tab_matcher "title:$tab_title"

    kitty @ set-tab-title $tab_title
    kitty @ launch --match $tab_matcher --copy-env \
        fish -c "npms"
    npmc

    kitty @ goto-layout --match $tab_matcher vertical
end