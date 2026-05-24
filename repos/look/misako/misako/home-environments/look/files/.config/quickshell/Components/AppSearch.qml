pragma Singleton
import QtQuick
import QtCore
import Quickshell

Singleton {
    id: root

    property bool iconsReady: waitaIconModel.filesReady && hicolorIconModel.filesReady

    function iconExists(iconName) {
        if (!iconName || iconName.length == 0) return false;
        return (Quickshell.iconPath(iconName, true).length > 0)
            && !iconName.includes("image-missing");
    }

    function steamIconPath(appid) {
        if (!appid) return "";
        for (let i = 0; i < steamIconModel.allFiles.length; ++i) {
            const fp = steamIconModel.allFiles[i].replace("file://", "");
            if (fp.includes(`/librarycache/${appid}/`)) {
                const base = fp.substring(fp.lastIndexOf("/") + 1);
                const nameNoExt = base.includes(".")
                    ? base.substring(0, base.lastIndexOf("."))
                    : base;
                if (/^[a-f0-9]{40}$/.test(nameNoExt)) {
                    console.log(fp);
                    return fp;
                }
            }
        }
        return "";
    }

    function scoreIconPath(fp) {
        let score = 0;
        if (fp.includes("/scalable/")) score += 1000;
        else {
            const m = fp.match(/\/(\d+)x\d+\//);
            if (m) score += parseInt(m[1]);
        }
        if (fp.endsWith(".svg")) score += 500;
        return score;
    }

    function waitaIconPath(iconName) {
        if (!iconName) return "";
        let fallback = "";
        let fallbackScore = -1;
        for (let i = 0; i < waitaIconModel.allFiles.length; ++i) {
            const fp = waitaIconModel.allFiles[i].replace("file://", "");
            const base = fp.substring(fp.lastIndexOf("/") + 1);
            const nameNoExt = base.includes(".")
                ? base.substring(0, base.lastIndexOf("."))
                : base;
            if (nameNoExt === iconName) {
                const score = scoreIconPath(fp) + 10000;
                if (score > fallbackScore) {
                    fallbackScore = score;
                    fallback = fp;
                }
            } else if (nameNoExt.includes(iconName)) {
                const score = scoreIconPath(fp);
                if (score > fallbackScore) {
                    fallbackScore = score;
                    fallback = fp;
                }
            }
        }
        return fallback;
    }

    function hicolorIconPath(iconName) {
        if (!iconName) return "";
        let bestFp = "";
        let bestScore = -1;
        for (let i = 0; i < hicolorIconModel.allFiles.length; ++i) {
            const fp = hicolorIconModel.allFiles[i].replace("file://", "");
            const base = fp.substring(fp.lastIndexOf("/") + 1);
            const nameNoExt = base.includes(".")
                ? base.substring(0, base.lastIndexOf("."))
                : base;
            if (nameNoExt === iconName || nameNoExt.includes(iconName)) {
                const isExact = nameNoExt === iconName;
                const score = scoreIconPath(fp) + (isExact ? 10000 : 0);
                if (score > bestScore) {
                    bestScore = score;
                    bestFp = fp;
                }
            }
        }
        return bestFp;
    }

    function guessIcon(str) {
        if (!str || str.length == 0) return Quickshell.iconPath("image-missing");
        const waitaPath = waitaIconPath(str);
        if (waitaPath !== "") return "file://" + waitaPath;
        const hiPath = hicolorIconPath(str);
        if (hiPath !== "") return "file://" + hiPath;
        if (str.startsWith("steam_app_")) {
            const appid = str.substring("steam_app_".length);
            const steamPath = steamIconPath(appid);
            if (steamPath !== "") return "file://" + steamPath;
        }
        return Quickshell.iconPath(str);
    }

    RecursiveFolderModel {
        id: steamIconModel
        folder: Qt.resolvedUrl(
            StandardPaths.writableLocation(StandardPaths.HomeLocation)
            + "/.local/share/guix-sandbox-home/.local/share/Steam/appcache/librarycache"
        )
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
        onFilesReady: console.log("Steam icons loaded:", allFiles.length)
    }

    RecursiveFolderModel {
        id: waitaIconModel
        folder: Qt.resolvedUrl(
            StandardPaths.writableLocation(StandardPaths.HomeLocation)
            + "/.guix-home/profile/share/icons/MoreWaita"
        )
        nameFilters: ["*.png", "*.svg", "*.xpm"]
        onFilesReady: console.log("Waita icons loaded:", allFiles.length)
    }

    RecursiveFolderModel {
        id: hicolorIconModel
        folder: Qt.resolvedUrl(
            StandardPaths.writableLocation(StandardPaths.HomeLocation)
            + "/.guix-home/profile/share/icons/hicolor"
        )
        nameFilters: ["*.png", "*.svg", "*.xpm"]
        onFilesReady: console.log("Hicolor icons loaded:", allFiles.length)
    }
}
