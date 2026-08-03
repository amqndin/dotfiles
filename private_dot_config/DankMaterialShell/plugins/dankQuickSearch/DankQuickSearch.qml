import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

QtObject {
    id: root

    property var pluginService: null
    property string pluginId: "dankQuickSearch"
    property string trigger: "!"
    property string defaultEngine: "duckduckgo"

    signal itemsChanged

    property var engines: [
        { id: "duckduckgo", name: "DuckDuckGo", icon: "material:search", prefix: "", url: "https://duckduckgo.com/?q=" },
        { id: "google", name: "Google", icon: "material:search", prefix: "g", url: "https://www.google.com/search?q=" },
        { id: "github", name: "GitHub", icon: "material:code", prefix: "gh", url: "https://github.com/search?q=" },
        { id: "youtube", name: "YouTube", icon: "material:play_circle", prefix: "yt", url: "https://www.youtube.com/results?search_query=" }
    ]

    Component.onCompleted: {
        if (!pluginService)
            return;
        trigger = pluginService.loadPluginData(pluginId, "trigger", "!");
        defaultEngine = pluginService.loadPluginData(pluginId, "defaultEngine", "duckduckgo");
    }

    function getDefaultEngine() {
        for (var i = 0; i < engines.length; i++) {
            if (engines[i].id === defaultEngine)
                return engines[i];
        }
        return engines[0];
    }

    function getItems(query) {
        if (!query || query.trim().length === 0) {
            return engines.map(function(e) {
                var isDefault = (e.id === defaultEngine);
                return {
                    name: e.name + (isDefault ? " (default)" : ""),
                    icon: e.icon,
                    comment: e.prefix ? ("Prefix: " + e.prefix) : "Default engine",
                    action: "info:",
                    categories: ["Quick Search"],
                    _preScored: 1000
                };
            });
        }

        var trimmed = query.trim();

        // Direct URL detection
        if (trimmed.match(/^https?:\/\//) || trimmed.match(/^[a-zA-Z0-9-]+\.[a-zA-Z]{2,}/)) {
            var url = trimmed;
            if (!url.match(/^https?:\/\//))
                url = "https://" + url;
            return [{
                name: "Open: " + trimmed,
                icon: "material:open_in_browser",
                comment: url,
                action: "open:" + url,
                categories: ["Quick Search"],
                _preScored: 1000
            }];
        }

        // Check for engine prefix
        var selectedEngine = getDefaultEngine();
        var searchQuery = trimmed;

        for (var i = 0; i < engines.length; i++) {
            var e = engines[i];
            if (e.prefix && (trimmed === e.prefix || trimmed.indexOf(e.prefix + " ") === 0)) {
                selectedEngine = e;
                searchQuery = trimmed.substring(e.prefix.length).trim();
                break;
            }
        }

        if (searchQuery.length === 0) {
            return [{
                name: "Search " + selectedEngine.name + "...",
                icon: selectedEngine.icon,
                comment: "Type your query",
                action: "info:",
                categories: ["Quick Search"],
                _preScored: 1000
            }];
        }

        var results = [];

        // Selected engine first
        results.push({
            name: searchQuery,
            icon: selectedEngine.icon,
            comment: "Search " + selectedEngine.name,
            action: "open:" + selectedEngine.url + encodeURIComponent(searchQuery),
            categories: ["Quick Search"],
            _preScored: 1000
        });

        // Other engines
        for (var j = 0; j < engines.length; j++) {
            if (engines[j].id !== selectedEngine.id) {
                results.push({
                    name: searchQuery,
                    icon: engines[j].icon,
                    comment: "Search " + engines[j].name,
                    action: "open:" + engines[j].url + encodeURIComponent(searchQuery),
                    categories: ["Quick Search"],
                    _preScored: 900
                });
            }
        }

        return results;
    }

    function executeItem(item) {
        if (!item?.action)
            return;
        var colonIdx = item.action.indexOf(":");
        if (colonIdx === -1)
            return;
        var actionType = item.action.substring(0, colonIdx);
        var actionData = item.action.substring(colonIdx + 1);

        if (actionType === "open" && actionData) {
            Quickshell.execDetached(["xdg-open", actionData]);
        }
    }

    onTriggerChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData(pluginId, "trigger", trigger);
    }

    onDefaultEngineChanged: {
        if (!pluginService)
            return;
        pluginService.savePluginData(pluginId, "defaultEngine", defaultEngine);
    }
}
