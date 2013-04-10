XML [] track;
//use pvectors to capture max/min values of lat, lon, time, alt
PVector elat, elon, ealt, etime;
int currentSeg = 0;
int currentTrack = 0;
float maxSize = 1000;

String filename = "samplewalk.gpx";
boolean animated = true;

float secsAfterMidnight;
float secsIncrement = 10;
int currentLink = 1;

void setup()
{
    XML root = loadXML(filename);
    track = root.getChildren("trk")[currentTrack].getChildren("trkseg")[0].getChildren("trkpt");
    findExtrema();
    //linearmap includes the size() command
    linearMap();
    
    secsAfterMidnight();
    secsAfterMidnight = etime.x;
}


void draw()
{
    if(!animated)
    {
        background(255);
        drawPath(track.length);
    }
    else
    {
        background(255);
        stroke(0);
        animate();
        drawTime(width/2, 50);
        secsAfterMidnight += secsIncrement;
    }
}

