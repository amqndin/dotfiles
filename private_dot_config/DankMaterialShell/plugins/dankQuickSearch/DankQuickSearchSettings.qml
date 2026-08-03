import QtQuick
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "dankQuickSearch"

    StyledText {
        width: parent.width
        text: I18n.tr("Quick Search Settings")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: I18n.tr("Search the web directly from the launcher")
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledRect {
        width: parent.width
        height: triggerColumn.implicitHeight + Theme.spacingL * 2
        radius: Theme.cornerRadius
        color: Theme.surfaceContainerHigh

        Column {
            id: triggerColumn
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingM

            StyledText {
                text: I18n.tr("Activation")
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
            }

            StringSetting {
                settingKey: "trigger"
                label: I18n.tr("Trigger Prefix")
                description: I18n.tr("Type this prefix to activate quick search")
                placeholder: "!"
                defaultValue: "!"
            }

            SelectionSetting {
                settingKey: "defaultEngine"
                label: I18n.tr("Default Search Engine")
                description: I18n.tr("Engine used when no prefix is specified")
                options: [
                    { value: "duckduckgo", label: "DuckDuckGo" },
                    { value: "google", label: "Google" },
                    { value: "github", label: "GitHub" },
                    { value: "youtube", label: "YouTube" }
                ]
                defaultValue: "duckduckgo"
            }
        }
    }

    StyledRect {
        width: parent.width
        height: infoColumn.implicitHeight + Theme.spacingL * 2
        radius: Theme.cornerRadius
        color: Theme.surface

        Column {
            id: infoColumn
            anchors.fill: parent
            anchors.margins: Theme.spacingL
            spacing: Theme.spacingM

            Row {
                spacing: Theme.spacingM

                DankIcon {
                    name: "info"
                    size: Theme.iconSize
                    color: Theme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    text: I18n.tr("Engine Prefixes")
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.Medium
                    color: Theme.surfaceText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            StyledText {
                text: I18n.tr("g — Google\ngh — GitHub\nyt — YouTube\n\nType a URL directly to open it in your browser.")
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.surfaceVariantText
                wrapMode: Text.WordWrap
                width: parent.width
                lineHeight: 1.4
            }
        }
    }
}
