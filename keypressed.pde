void keyPressed()
{
    if(key=='c') exportCurrentPathAsCSV();
   
}

void exportCurrentPathAsCSV()
{
    String fileout = "outs/" +  track[0].getString("Date") + "_" + currentTrack + "_" + currentSeg + ".csv";
    PrintWriter output = createWriter(fileout);
    output.println("dt, date, hour, minutes, seconds, lat, lon, elevation");
    for(int i = 0; i<track.length; i++)
    {
        String lineOut = "";
        lineOut += track[i].getChild("time").getContent() + ",";
        lineOut += track[i].getString("Date") + ",";
        lineOut += track[i].getString("Hour") + ",";
        lineOut += track[i].getString("Minute") + ",";
        lineOut += track[i].getString("Second") + ",";
        lineOut += track[i].getString("lat") + ",";
        lineOut += track[i].getString("lon") + ",";
        lineOut += track[i].getChild("ele").getContent();
        output.println(lineOut);
        
    }
    
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    println("file written");
}
