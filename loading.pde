void findExtrema(XML []  tr)
{
    /*
        Find maxima and minima of lat, lon
    */
   
    
        
        for(int i = 0; i<tr.length; i++)
        {
            float lon = tr[i].getFloat("lon");
            if(lon<elon.x) elon.x = lon;
            if(lon>elon.y) elon.y = lon;
          
            float lat = tr[i].getFloat("lat");
            if(lat<elat.x) elat.x = lat;
            if(lat>elat.y) elat.y = lat; 
           
           float alt = float(tr[i].getChild("ele").getContent());
            if(alt<ealt.x) ealt.x = alt;
            if(alt>ealt.y) ealt.y = alt;  
        } 
        
        println(elat + " " + elon + " " + ealt);  
}

void secsAfterMidnight()
{
    etime = new PVector(24*60*60,  0);
    
    for(XML [] thisTrack:tracks)
    {
      for(int i = 0; i<thisTrack.length; i++)
      {
          String t = thisTrack[i].getChild("time").getContent();
          String dt[] = split(t, 'T');
          String alltime [] = split(dt[1], '.');
          String time[] = split(alltime[0], ':');
          thisTrack[i].setString("Date", dt[0]);
          thisTrack[i].setString("Hour", time[0]);
          thisTrack[i].setString("Minute", time[1]);
          thisTrack[i].setString("Second", time[2]);
          //seconds after midnight
          float sam = (60*60*float(time[0])) + (60*float(time[1])) + float(time[2]);
          thisTrack[i].setFloat("sam", sam);
          if(sam<etime.x) etime.x = sam;
          if(sam>etime.y) etime.y = sam;
        
      } 
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
    println((elat.y - elat.x) + " " + (elon.y - elon.x) + " "  + " " + cos(0.5*radians(elat.x+elat.y)) +  " " + dydx);
    float xw, yw;
    if(dydx>1) size(int(1000/dydx), 1000);
    else size(1000, int(1000*dydx));
    //println(width + " " + height);
    for(int j =0; j<tracks.size(); j++)
    {
      XML [] thisTrack = tracks.get(j);
      for(int i = 0; i<thisTrack.length; i++)
      {
          thisTrack[i].setFloat("x", map(thisTrack[i].getFloat("lon"), elon.x, elon.y, 0, width));
          thisTrack[i].setFloat("y", map(thisTrack[i].getFloat("lat"), elat.x, elat.y, height, 0));
      }
    }
}
