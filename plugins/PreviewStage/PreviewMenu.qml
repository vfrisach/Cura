// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura

import QtGraphicalEffects 1.0 // For the dropshadow

Item
{
    id: previewMenu

    property real itemHeight: height - 2 * UM.Theme.getSize("default_lining").width

    UM.I18nCatalog
    {
        id: catalog
        name: "cura"
    }

    anchors
    {
        left: parent.left
        right: parent.right
        leftMargin: UM.Theme.getSize("wide_margin").width * 10
        rightMargin: UM.Theme.getSize("wide_margin").width * 10
    }

    Row
    {
        //ÑAPA: OCULTO EL PANEL COMPLETO PROVISIONALMENTE
        // visible: false
        id: stageMenuRow

        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 2 * UM.Theme.getSize("wide_margin").width
        height: parent.height

        Cura.ViewsSelector
        {
            id: viewsSelector
            height: parent.height
            width: UM.Theme.getSize("views_selector").width
            headerCornerSide: Cura.RoundedRectangle.Direction.Left
        }

        // Separator line
        Rectangle
        {
            height: parent.height
            // If there is no viewPanel, we only need a single spacer, so hide this one.
            visible: viewPanel.source != ""
            width: visible ? UM.Theme.getSize("default_lining").width : 0

            color: UM.Theme.getColor("lining")
        }

        // This component will grow freely up to complete the width of the row.
        Loader
        {
            id: viewPanel
            height: parent.height
            // width: source != "" ? (previewMenu.width - viewsSelector.width - printSetupSelectorItem.width - 2 * (UM.Theme.getSize("wide_margin").width + UM.Theme.getSize("default_lining").width)) : 0
            width: source != "" ? (previewMenu.width - viewsSelector.width - returnToPrepareButton.width - 2 * (UM.Theme.getSize("wide_margin").width + UM.Theme.getSize("default_lining").width)) : 0
            source: UM.Controller.activeView != null && UM.Controller.activeView.stageMenuComponent != null ? UM.Controller.activeView.stageMenuComponent : ""
        }

        // Separator line
        Rectangle {
            height: parent.height
            width: UM.Theme.getSize("default_lining").width
            color: UM.Theme.getColor("lining")
        }
        
       //Botón para volver al stage de preparación
        Button {
            id: returnToPrepareButton
            text: catalog.i18nc("@button", "Prepare")
            height: UM.Theme.getSize("stage_menu").height
            width: UM.Theme.getSize("stage_menu").height
            onClicked:  UM.Controller.setActiveStage("PrepareStage")
            hoverEnabled: true

            contentItem: Item
            {
                anchors.fill: parent
                UM.RecolorImage
                {
                    id: buttonIcon
                    anchors.centerIn: parent
                    source: UM.Theme.getIcon("back")
                    width: UM.Theme.getSize("button_icon").width
                    height: UM.Theme.getSize("button_icon").height
                    color: UM.Theme.getColor("icon")
                    sourceSize.height: height
                }
            }

            background: Cura.RoundedRectangle {
                id: background
                height: UM.Theme.getSize("stage_menu").height
                width: UM.Theme.getSize("stage_menu").height
                cornerSide: Cura.RoundedRectangle.Direction.Right
                radius: UM.Theme.getSize("default_radius").width
                color: returnToPrepareButton.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
            }

            DropShadow {
                id: shadow
                // Don't blur the shadow
                radius: 0
                anchors.fill: background
                source: background
                verticalOffset: 2
                visible: true
                color: UM.Theme.getColor("action_button_shadow")
                // Should always be drawn behind the background.
                z: background.z - 1
            }
            Cura.ToolTip {
                id: tooltip
                tooltipText: returnToPrepareButton.text
                visible: returnToPrepareButton.hovered
                contentAlignment: Cura.ToolTip.ContentAlignment.AlignRight
            }
        }
    }
}
