import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0


Item {
    property alias cfg_showPointer: showPointer.checked
    property alias cfg_delayTime: delayTime.value
    property alias cfg_copyToClipboard: copyToClipboard.checked


    property int textfieldWidth: theme.defaultFont.pointSize * 30

    GridLayout {
        columns: 3

	Item {
            width: 1
            height: 25
        }

        Item {
            width: 3
            height: 25
        }

        CheckBox {
	  id: showPointer
	  Layout.columnSpan: 3
	  text: i18n("Include mouse pointer")  
        }

        Label {
            text: i18n("Delay time:")
        }

        SpinBox {
	  id: delayTime
	  minimumValue: 0
	  maximumValue: 100
	  
	  suffix: i18nc("Abbreviation for seconds", "sec")  
	  
	  stepSize: 1
	  Layout.columnSpan: 2
        }
        
        CheckBox {
	  id: copyToClipboard
	  Layout.columnSpan: 3
	  text: i18n("Copy capture to clipboard")  
        }
    }
}
 
