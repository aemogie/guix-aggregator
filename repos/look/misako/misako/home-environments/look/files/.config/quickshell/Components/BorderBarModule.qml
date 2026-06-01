import ".."

BarModule {
    border.width: 1
    border.color: Theme.vars.colorHollow

    // This fixes border calc
    // leftMargin: Theme.vars.barModuleSideMargin - border.width
    // rightMargin: Theme.vars.barModuleSideMargin - border.width
}
