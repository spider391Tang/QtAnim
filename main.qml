import QtQuick 2.15
import QtQuick.Window 2.15
import FileIO 1.0
// import com.yourcompany 1.0

Window {

    property var detectedObjects: []
    property int currentIndex: 0

    visible: true

    width: 1280
    height: 720

    // FileReader {
    //     id: fileReader
    // }
    FileIO {
        id: myFile
        source: "D:/projects/QtAnim/goalert.txt"
        onError: console.log(msg)
    }

    Rectangle {
        id: bbox
        color: "transparent"
        border.color: "red"
        border.width: 3
    }

    Timer {
        interval: 150
        running: true
        repeat: true
        onTriggered: {
            updateRect();
        }
    }

    function parseLine(line) {
        var parts = line.split(/(\s+)/);
        console.log( parts[0] );
        console.log( parts[1] );
        console.log( parts[2] );
        console.log( parts[3] );
        console.log( parts[4] );
        console.log( parts[5] );
        console.log( parts[6] );
        console.log( parts[7] );
        console.log( parts[8] );
        return {
            "time": parts[0],
            "x": parseInt( parts[4] ),
            "y": parseInt( parts[8] ),
            "width": parseInt( parts[12] ),
            "height": parseInt( parts[16] ),
            "distance": parseInt( parts[20] )
        }
    }

    function updateRect() {
        if (detectedObjects.length === 0) return;

        var currentObject = detectedObjects[currentIndex];
        bbox.x = currentObject.x;
        bbox.y = currentObject.y;
        bbox.width = currentObject.width;
        bbox.height = currentObject.height;

        currentIndex++;
        if (currentIndex >= detectedObjects.length) currentIndex = 0;
    }

    Text {
        id: myText
        text: "Hello World"
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        // console.log( "WRITE"+ myFile.write("TEST"));
        // myText.text =  myFile.read();
        // detectedObjects = fileReader.readFile("goalert.txt");
        // var fileData = fileReader.read(Qt.resolvedUrl("goalert.txt"));
        // var lines = fileData.split("\n");
        // for (var i = 0; i < lines.length; i++) {
        //     var line = lines[i];
        //     detectedObjects.push(parseLine(line));
        // }
        var fileData = myFile.read();
        var lines = fileData.split("\n");
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            console.log( line );
            
            detectedObjects.push(parseLine(line));
        }
    }
}
