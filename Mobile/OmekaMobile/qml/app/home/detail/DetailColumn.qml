import QtQuick 2.5
import "viewers"
import "../../base"
import "../../../utils"

ScaleColumn {
    y: parent.margins
    width: parent.width - 2 * parent.margins
    height: childrenRect.height
    anchors.horizontalCenter: parent.horizontalCenter

    /*! \qmlproperty
        Currently selected item
    */
    property variant item: ItemManager.current

    // add formatted metadata to info panel
    Component.onCompleted: {
        info.text = "";
         if(item.metadata){
             var element
             for(var i=0; i<item.metadata.length; i++) {
                 element = item.metadata[i];
                 info.text += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p>"
             }
         }
    }

    //actions
    toolbar: DetailToolbar { id: bar }

    //media view
    viewer: MediaViewer {
        id: image
        source: item.image
    }

    //info panel
    info: OmekaText {
        id: info
        width: parent.width
        height: contentHeight
        _font: Style.metadataFont
    }
}