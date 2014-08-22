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
    currentLink = 1;
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
      
      noStroke();
      fill(255,0,0);
      ellipse(x, y, 5,5);
      stroke(255,0,0);
      noFill();
      ellipse(x, y, (secsAfterMidnight%60)/3, (secsAfterMidnight%60)/3);
    }
    else
    {
       //println("WTAF");
      drawPath(currentLink);
    }
}

void drawTime(int x, int y)
{
    rectMode(CENTER);
    noStroke();
    stroke(0);
    fill(100);
    rect(x,y, 150, 40);
    
    int hour = int(secsAfterMidnight/(60*60));
    int minute = int(secsAfterMidnight/60)%60;
    int second = int(secsAfterMidnight)%60;
    
    fill(255);
    String timeString = nf(hour,2,0) + " : " + nf(minute, 2,0) + " : " + nf(second, 2,0);
    text(timeString, x -40, y);
}

