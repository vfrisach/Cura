// Inspirado en el de https://github.com/BCN3D/Cura/resources/qml/PrintModeComboBox
import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

import UM 1.2 as UM
import Cura 1.0 as Cura

Item
{
    id: printModeCell

    height: childrenRect.height

    property real labelColumnWidth: Math.round(width / 3)

    UM.SettingPropertyProvider {
        id: printMode

        containerStackId: Cura.MachineManager.activeMachine.definition.id
        key: "print_mode"
        watchedProperties: [ "label" ]
        storeIndex: 0
    }

    UM.I18nCatalog{id: catalog; name:"cura"}

    signal showTooltip(Item item, point location, string text)
    signal hideTooltip()

    Cura.IconWithText {
        id: printModeTitle
        anchors.top: parent.top
        anchors.left: parent.left
        visible: true
        source: UM.Theme.getIcon("category_machine")
        text: catalog.i18nc("@label", printMode.properties.label)
       
        font: UM.Theme.getFont("medium")
        width: labelColumnWidth
        // Component.onCompleted : console.log("valor de la etieuqta: " + printMode.properties.label)

    }

    Item {
        id: printModeContainer
        height: printModeComboBox.height

        anchors
        {
            left: printModeTitle.right
            right: parent.right
            verticalCenter: printModeTitle.verticalCenter
        }

        ComboBox {
            id: printModeComboBox
            model: printModeModel
            width: 200
            // anchors.right: parent.right
            // anchors.rightMargin: UM.Theme.getSize("thick_margin").width
            anchors.verticalCenter: parent.verticalCenter
            currentIndex: printModes.visible ? printModes.activeIndex : -1
            onActivated: printModes.changeProperty(printModeModel.get(index).text)
            style: UM.Theme.styles.combobox
        }   
    }





    ListModel {
        id: printModeModel
        Component.onCompleted: populatePrintModeModel()
    }

    Cura.PrintModesModel {
        id: printModes
        onPrintModeChanged: updateIndex()
        onPrinterChanged: updateValues()
    }

    function updateValues() {
        printModes.update();
        populatePrintModeModel();
        updateIndex();
    }

    function updateIndex() {
        printModeComboBox.currentIndex = printModes.activeIndex;
    }

    function populatePrintModeModel() {
        printModeModel.clear();
        if (printModes.visible) {
            for (var i in printModes.printModes) {
                printModeModel.append({
                    text: printModes.printModes[i],
                })
            }
        }
    }


}
