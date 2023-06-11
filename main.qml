import QtQuick 2.15
import QtQuick.Window 2.15
import FileIO 1.0
// import com.yourcompany 1.0

Window {

    property var detectedObjects: []
    property int currentIndex: 0

    property real currentX: 0.0
    property real currentY: 0.0
    property real currentWidth: 0.0
    property real currentHeight: 0.0
    property real distance: 0.0

    visible: true

    width: Screen.width
    height: Screen.height

    color: "black"

    onWidthChanged: {
        console.log("Width is now " + width);
        console.log("Screen Width is now " + Screen.width);
        console.log("Screen Height is now " + Screen.height);

    }
    onHeightChanged: {
        console.log("Height is now " + height);
        console.log("Screen Width is now " + Screen.width);
        console.log("Screen Height is now " + Screen.height);
    }

    FileIO {
        id: myFile
        source: "C:/Users/tangquincy/projects/QtAnim/goalert.txt"
        onError: console.log(msg)
    }

    Rectangle {
        id: iBbox
        color: "transparent"
        border.color: "red"
        border.width: 3

        Behavior on x {
            NumberAnimation { duration: 200; easing.type: iStillControls.easingType }
        }

        Behavior on y {
            NumberAnimation { duration: 200; easing.type: iStillControls.easingType }
        }

        Behavior on width {
            NumberAnimation { duration: 200; easing.type: iStillControls.easingType }
        }

        Behavior on height {
            NumberAnimation { duration: 200; easing.type: iStillControls.easingType }
        }
    }

    Image {
        id: iImage

        anchors.bottom: iBbox.bottom
        anchors.left: iBbox.left
        anchors.right: iBbox.right

        source: "images/garmin_2ar_navi_start_alert_frame_green_01.png"
        height: ( 50 / 264 ) * width
        // width: iSlider.value
        // height: ( 50 / 264 ) * iSlider.value
        // visible: false // We make this invisible as we will see it through the OpacityMask
    }


    Timer {
        interval: 150
        running: true
        repeat: true
        onTriggered: {
            updateRect();
        }
    }

    PhotoCaptureControls {
        id: iStillControls
        anchors.fill: parent
        camera: camera
        visible: true
        onPreviewSelected: cameraUI.state = "PhotoPreview"
        onVideoModeSelected: cameraUI.state = "VideoCapture"
    }

    function parseLine(line) {
        var parts = line.split( " " );
        // console.log( parts[0] );
        // console.log( parts[1] );
        // console.log( parts[2] );
        // console.log( parts[3] );
        // console.log( parts[4] );
        return {
            "time": parts[0],
            "x": parseInt( parts[1] ),
            "y": parseInt( parts[2] ),
            "width": parseInt( parts[3] ),
            "height": parseInt( parts[4] ),
            "distance": parseInt( parts[5] )
        }
    }

    function calculateIoU(bbox1, bbox2) {
        var xA = Math.max(bbox1.x, bbox2.x);
        var yA = Math.max(bbox1.y, bbox2.y);
        var xB = Math.min(bbox1.x + bbox1.width, bbox2.x + bbox2.width);
        var yB = Math.min(bbox1.y + bbox1.height, bbox2.y + bbox2.height);

        var intersectionArea = Math.max(0, xB - xA + 1) * Math.max(0, yB - yA + 1);

        var bbox1Area = bbox1.width * bbox1.height;
        var bbox2Area = bbox2.width * bbox2.height;

        var iou = intersectionArea / (bbox1Area + bbox2Area - intersectionArea);
        return iou;
    }


    function updateRect() {
        if (detectedObjects.length === 0) return;

        var currentObject = detectedObjects[currentIndex];

        // The detected object is from resolution 1280x720.
        var scale = ( Screen.width - iStillControls.buttonsPanelWidth ) / 1280;

        var bbox = {
            x: 0,
            y: 0,
            width: 0,
            height: 0
        };
        bbox.x = currentObject.x * scale;
        bbox.y = currentObject.y * scale;
        bbox.width = currentObject.width * scale;
        bbox.height = currentObject.height * scale;

        var iou = calculateIoU( bbox, iBbox );
        // console.log( iou );

        if( !iStillControls.smoothEnabled || iou < 0.8 ) {
            iBbox.x = bbox.x;
            iBbox.y = bbox.y;
            iBbox.width = bbox.width;
            iBbox.height = bbox.height;
        }

        currentIndex++;
        if (currentIndex >= detectedObjects.length) currentIndex = 0;
    }

    Component.onCompleted: {
        var fileData = myFile.read();
        var lines = fileData.split("\n");
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            // console.log( line );
            
            detectedObjects.push(parseLine(line));
        }

        console.log(`Right panel width: ${iStillControls.buttonsPanelWidth}`);
        console.log(`Current screen dimensions are ${Screen.width} x ${Screen.height}`);
    }
}
