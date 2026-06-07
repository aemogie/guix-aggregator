import QtQuick
import ".."
import "../Services"
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets

GridLayout {
    columns: 2
    id: root
    columnSpacing: 10

    property string rawOutput: MullvadService.relayList

    property string filterPattern: ""

    property bool filterValid: true

    property var allServers: []

    property var filteredServers: []


    onRawOutputChanged: _parse()
    onFilterPatternChanged: _applyFilter()

    function _parse() {
        var servers = []

        var countryRe = /^(\w[\w\s]+)\s+\((\w+)\)\s*$/gm
        var cityRe = /^\s{8}([\w\s]+)\s+\((\w+)\)\s+@/gm

        var countryMap = {}
        var currentCountry = ""

        var lines = rawOutput.split("\n")
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i]

            var cm = line.match(/^(\w[\w\s]+)\s+\((\w+)\)\s*$/)
            if (cm) {
                currentCountry = cm[1].trim()
                continue
            }

            var city = line.match(/^\s{8}([\w\s]+)\s+\((\w+)\)\s+@/)
            if (city && currentCountry) {
                countryMap[city[2].trim()] = currentCountry
            }
        }

        var serverRe = /^\s+([\w-]+)\s+\([^)]+\)\s+-\s+hosted by\s+([^(]+?)\s+\((\w+)\)/gm

        var match
        while ((match = serverRe.exec(rawOutput)) !== null) {
            var name   = match[1].trim()
            var host   = match[2].trim()
            var status = match[3].trim()

            var prefixMatch = name.match(/^(.*?)-wg-\d+$/)
            var prefix = prefixMatch ? prefixMatch[1] : name

            var cityCode = prefix.split("-").pop()
            var country = countryMap[cityCode] || ""

            servers.push({
                name:    name,
                prefix:  prefix,
                host:    host,
                rented:  status === "rented",
                country: country
            })
        }

        allServers = servers
        _applyFilter()
    }

    function _applyFilter() {
        if (filterPattern === "") {
            filterValid = true
            filteredServers = allServers.slice()
            return
        }
        try {
            var re = new RegExp(filterPattern)
            filterValid = true
            filteredServers = allServers.filter(function(s) {
                return re.test(s.name)
            })
        } catch (e) {
            filterValid = false
            filteredServers = []
        }
    }

    Repeater {
        model: root.filteredServers

        delegate: WrapperRectangle {
            Layout.fillWidth: true
            radius: Theme.vars.roundness
            // color: index % 2 === 0 ? "#1e1e2e" : "#2a2a3e"
            color: MullvadService.hostname === modelData.name ? Theme.vars.colorFill : Theme.vars.colorMain
            border.color: "#444466"
            border.width: 1
            margin: 5

            RowLayout {
                spacing: 5

                MonoStyledText {
                    text: modelData.name
                    color: MullvadService.hostname === modelData.name ? Theme.vars.colorMain : Theme.vars.colorFont
                    font.pixelSize: 13
                }

                MonoStyledText {
                    text: modelData.host
                    color: MullvadService.hostname === modelData.name ? Theme.vars.colorMain : Theme.vars.colorFill
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                InteractArea {
                    onLeftClick: MullvadService.set_relay(modelData.name)
                }
            }
        }
    }
    component CategoryText: MonoStyledText {
        color: Theme.vars.colorFont
        font.pixelSize: 16
    }
    component DescriptionText: MonoStyledText {
        color: Theme.vars.colorFill
        font.pixelSize: 12
        wrapMode: Text.WordWrap
    }
}
