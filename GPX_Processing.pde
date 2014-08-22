XML [] track;
ArrayList<XML[]> tracks;
//use pvectors to capture max/min values of lat, lon, time, alt
PVector elat, elon, ealt, etime;
int currentSeg = 0;
int currentTrack = 0;
float maxSize = 1000;

String filename = "samplewalk.gpx";
String rootname = "BoothTest";
boolean animated = true;

float secsAfterMidnight;
float secsIncrement = 10;
int currentLink = 1;

void setup()
{
  
    elat = new PVector(90, -90);
    elon = new PVector(180, -180);
    ealt = new PVector(20000, -20000);
    tracks = new ArrayList<XML[]>();

    //linearmap includes the size() command
    loader();
    linearMap();
    
    secsAfterMidnight();
    secsAfterMidnight = etime.x;
}

void loader()
{
    for(int i = 2; i<3; i++)
    {
        XML root = loadXML(rootname + i +  ".gpx");
        
        if(!(root==null)) 
        {
            XML [] t = root.getChildren("trk")[currentTrack].getChildren("trkseg")[0].getChildren("trkpt");
            tracks.add(t);
            findExtrema(t);
            println(rootname + i +  ".gpx");
        }
    }
    
    
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
        //background(255);
        stroke(0);
        for(int i = 0; i<tracks.size(); i++)
        {
            track = tracks.get(i);
            animate();
        }
        drawTime(width/2, 50);
        secsAfterMidnight += secsIncrement;
    }
}

