import QtQuick
import Qt.labs.folderlistmodel

Item {
    id: root

    property url folder
    property var nameFilters: ["*"]
    property var allFiles: []
    property bool ready: false

    signal filesReady()

    property var _selfComponent: null

    function _getSelfComponent() {
        if (!_selfComponent) {
            _selfComponent = Qt.createComponent(Qt.resolvedUrl("RecursiveFolderModel.qml"))
        }
        return _selfComponent
    }

    function _collect() {
        var found = []
        var subdirs = []

        for (var i = 0; i < _mainModel.count; i++) {
            if (_mainModel.isFolder(i))
                subdirs.push(_mainModel.get(i, "fileURL"))
            else
                found.push(_mainModel.get(i, "fileURL").toString())
        }

        allFiles = found
        _pendingDirs = subdirs.length
        _resolvedDirs = 0

        if (subdirs.length === 0) {
            ready = true
            filesReady()
            return
        }

        var comp = _getSelfComponent()
        for (var j = 0; j < subdirs.length; j++) {
            var child = comp.createObject(root, {
                folder: subdirs[j],
                nameFilters: root.nameFilters
            })
            ;(function(c) {
                c.filesReady.connect(function() {
                    root.allFiles = root.allFiles.concat(c.allFiles)
                    c.destroy()
                    root._resolvedDirs++
                    if (root._resolvedDirs >= root._pendingDirs) {
                        root.ready = true
                        root.filesReady()
                    }
                })
            })(child)
        }
    }

    property int _pendingDirs: 0
    property int _resolvedDirs: 0

    FolderListModel {
        id: _mainModel
        folder: root.folder
        showFiles: true
        showDirs: true
        showHidden: false
        nameFilters: root.nameFilters

        onStatusChanged: {
            if (status === FolderListModel.Ready)
                root._collect()
        }
    }
}
