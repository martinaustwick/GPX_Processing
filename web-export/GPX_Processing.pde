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

void drawPath(int finalPoint)
{
    stroke(0);
    for(int i = 1; i<finalPoint; i++)
    {
        line(track[i-1].getFloat("x"), track[i-1].getFloat("y"), track[i].getFloat("x"), track[i].getFloat("y")); 
    }
}

void animate()
{
    while(secsAfterMidnight>track[currentLink].getFloat("sam") && currentLink<track.length-1)
    {
        currentLink++;
        
    }
    
    if(secsAfterMidnight<=track[currentLink].getFloat("sam"))
    {
      float x = map(secsAfterMidnight, track[currentLink-1].getFloat("sam"), track[currentLink].getFloat("sam"), track[currentLink-1].getFloat("x"), track[currentLink].getFloat("x"));
      float y = map(secsAfterMidnight, track[currentLink-1].getFloat("sam"), track[currentLink].getFloat("sam"), track[currentLink-1].getFloat("y"), track[currentLink].getFloat("y"));
      drawPath(currentLink-1);
      line(x,y,track[currentLink-1].getFloat("x"),track[currentLink-1].getFloat("y"));
    }
    else
    {
      drawPath(currentLink);
    }
}

void drawTime(int x, int y)
{
    rectMode(CENTER);
    noStroke();
    fill(100);
    rect(x,y, 150, 40);
    
    int hour = int(secsAfterMidnight/(60*60));
    int minute = int(secsAfterMidnight/60)%60;
    int second = int(secsAfterMidnight)%60;
    
    fill(255);
    String timeString = nf(hour,2,0) + " : " + nf(minute, 2,0) + " : " + nf(second, 2,0);
    text(timeString, x -40, y);
}

//void keyPressed()
//{
//    if(key=='c') exportCurrentPathAsCSV();
//}
//
//void exportCurrentPathAsCSV()
//{
//    String fileout = "outs/" +  track[0].getString("Date") + "_" + currentTrack + "_" + currentSeg + ".csv";
//    PrintWriter output = createWriter(fileout);
//    output.println("dt, date, hour, minutes, seconds, lat, lon, elevation");
//    for(int i = 0; i<track.length; i++)
//    {
//        String lineOut = "";
//        lineOut += track[i].getChild("time").getContent() + ",";
//        lineOut += track[i].getString("Date") + ",";
//        lineOut += track[i].getString("Hour") + ",";
//        lineOut += track[i].getString("Minute") + ",";
//        lineOut += track[i].getString("Second") + ",";
//        lineOut += track[i].getString("lat") + ",";
//        lineOut += track[i].getString("lon") + ",";
//        lineOut += track[i].getChild("ele").getContent();
//        output.println(lineOut);
//        
//    }
//    
//    output.flush(); // Writes the remaining data to the file
//    output.close(); // Finishes the file
//    println("file written");
//}
void findExtrema()
{
    /*
        Find maxima and minima of lat, lon
    */
    elat = new PVector(90, -90);
    elon = new PVector(180, -180);
    ealt = new PVector(20000, -20000);
    
        
        for(int i = 0; i<track.length; i++)
        {
            float lon = track[i].getFloat("lon");
            if(lon<elon.x) elon.x = lon;
            if(lon>elon.y) elon.y = lon;
          
            float lat = track[i].getFloat("lat");
            if(lat<elat.x) elat.x = lat;
            if(lat>elat.y) elat.y = lat; 
           
           float alt = float(track[i].getChild("ele").getContent());
            if(alt<ealt.x) ealt.x = alt;
            if(alt>ealt.y) ealt.y = alt;  
        } 
        
        println(elat + " " + elon + " " + ealt);  
}

void secsAfterMidnight()
{
    etime = new PVector(24*60*60,  0);
    
    for(int i = 0; i<track.length; i++)
    {
        String t = track[i].getChild("time").getContent();
        String dt[] = split(t, 'T');
        String alltime [] = split(dt[1], '.');
        String time[] = split(alltime[0], ':');
        track[i].setString("Date", dt[0]);
        track[i].setString("Hour", time[0]);
        track[i].setString("Minute", time[1]);
        track[i].setString("Second", time[2]);
        //seconds after midnight
        float sam = (60*60*float(time[0])) + (60*float(time[1])) + float(time[2]);
        track[i].setFloat("sam", sam);
        if(sam<etime.x) etime.x = sam;
        if(sam>etime.y) etime.y = sam;
      
    } 
}

void linearMap()
{
    /*
      Even using a linear map we need to account for
      dy = d(lat);
      dx = d(lon)*cos(lat);
    */
    float dydx = (elat.y - elat.x)/((elon.y - elon.x)*cos(0.5*radians(elat.x+elat.y)));
    //println((elat.y - elat.x) + " " + (elon.y - elon.x) + " "  + " " + cos(0.5*radians(elat.x+elat.y)) +  " " + dydx);
    float xw, yw;
    if(dydx>1) size(int(1000/dydx), 1000);
    else size(1000, int(1000*dydx));
    //println(width + " " + height);
    float lonmid = 0.5*(elon.x + elon.y);
    float lonhw = 0.5*(elon.y - elon.x);
    float latmid = 0.5*(elat.x + elat.y);
    float lathw = 0.5*(elat.y - elat.x);
    float buffer = 1.3;
    
    for(int i = 0; i<track.length; i++)
    {
        track[i].setFloat("x", map(track[i].getFloat("lon"), lonmid - buffer*lonhw, lonmid + buffer*lonhw, 0, width));
        track[i].setFloat("y", map(track[i].getFloat("lat"), latmid - buffer*lathw, latmid + buffer*lathw, height, 0));
    }
}

